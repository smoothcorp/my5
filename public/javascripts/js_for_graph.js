function setup_graph_screen_1(dates,values,round) {
    var chart;
    //  =========================================================================================================
    countin_direction = function( count, start_date, count_of_month ) {
        // Вычисление количества дней/round > 7 ( вычисление направления отсчета - flag )

        var splited_first_date = start_date.split(' ');

        var sum_of_days_in_seven = 0;
        i = 0;
        var z = 1 + 7 * count_of_month;
        while ( ++i < z ) {
            dayCount = new Date(splited_first_date[0], splited_first_date[1] - 1 + i, 0).getDate();
            sum_of_days_in_seven += dayCount;
        }

        if ( count > sum_of_days_in_seven ) {
            return false;
        }
        else {
            return true;
        }
    };

    counting_of_days = function( year, month, direction ) {
        //  Составляем массив из количества дней в месяце

        var count_of_day_in_month = [];
        i = 0;

        while ( ++i < 90 ) {
            if ( direction ) {
                dayCount = new Date(year, month + i, 0).getDate();
            }
            else {
                dayCount = new Date(year, month + 2 - i, 0).getDate();
            }

            count_of_day_in_month.push(dayCount);
        }
        return count_of_day_in_month;
        //   Это если начать с МАЯ ( пятый месяц )
        //   count_of_day_in_month => [31, 30, 31, 31, 30...
    };

    function  slicing_for_day_and_week ( values, dates, round ) {

        Array.prototype.each_slice_seven = function( size, callback ) {
            for ( var i = 0, l = this.length; i < l; ) {
                callback.call(this, this.slice(i, i + size));
                i += size;
            }
        };
        values_arr = [];
        dates_arr = [];

        /*Count!*/
        avarage = 0;
        values.each_slice_seven(7, function( sub_array ) {
            $.each(sub_array, function() {
                avarage += this;
            });

        values_arr.push(avarage);
        avarage = 0;
        });

        /*Weeks!*/
        dates.each_slice_seven(7, function( sub_array ) {
            dates_arr.push(sub_array[0]);
            });

        return [dates_arr, values_arr];
    }


    var from_date, to_date, count_of_data, dayCount, count_of_day_arr, checked_only_days, returned_data, count_of_month;
    var values_arr = [];
    var  dates_arr = [];

    var separated = false;
    if ($("#department_view_mode").val() == "separated")
        separated = true;
    if (!separated)
        values = values[0];

    count_of_data = dates.length;
    from_date = dates[0];
    to_date = dates[dates.length - 1];


    if ( round == 1 || round == 7 ) {
        // Отображение для дней и недель
        // Должны оставить только 7мь точек ( 7мь дат )

        //if ( (round * 7) > count_of_data ) {
        if ( round == 7 ) {
            if (separated) {
                returned_data = slicing_for_day_and_week(values[0], dates, round);
                var dates_buf = returned_data[0].slice(0);//slice(0) hack for copy array, otherwise this is make link to array
                values = values.map( function (value) {
                  returned_data = slicing_for_day_and_week(value, dates, round);
                  return returned_data[1];
                } );
                dates = dates_buf;
            }
            else {
                returned_data = slicing_for_day_and_week(values, dates, round);
                dates = returned_data[0];
                values = returned_data[1];
            }
        }

        //}
        //else {
        //  values = values.reverse().slice(0, 7 * round).reverse();
        //  dates = dates.reverse().slice(0, 7 * round).reverse();
        //  if ( round == 7 ) {
        //    returned_data = slicing_for_day_and_week(values, dates, round);
        //    dates = returned_data[0];
        //    values = returned_data[1];
        //  }
        //}


    }
    else if ( round > 10 ) { // для всех round 30, 60, 90, 120...
        // Отображение для одного месяца

        // flag - больше семи точек или меньше ( откуда начинать считать );
        // если false - нужено ситать от конца;
        // если true считаем от начала.

        count_of_month = round / 30;

        // countin_direction - убрали, так как не нужно отображать последние 7мь месяцев
        // надо отобразить все месяцы
        // var flag = countin_direction(count_of_data, from_date, count_of_month);

        var flag = true;


        if ( flag ) {
            var splited_from_date = from_date.split(' ');
            var from_date_year = splited_from_date[0];
            var from_date_month = splited_from_date[1] - 1; // for Javascript nedd '-1'

            count_of_day_arr = counting_of_days(from_date_year, from_date_month, true)
        }
        else {
            var splited_to_date = to_date.split(' ');
            var to_date_year = splited_to_date[0];
            var to_date_month = splited_to_date[1] - 1; // for Javascript nedd '-1'
            var to_date_day = splited_to_date[2];

            count_of_day_arr = counting_of_days(to_date_year, to_date_month, false)
        }


        var new_arr = [];
        var sum_of_days = 0;

        for ( var h = 0; h < ( count_of_day_arr.length - count_of_month + 1 ); h = h + count_of_month ) {
            for ( var g = 0; g < count_of_month; g++ ) {
                sum_of_days += count_of_day_arr[h + g];
            }
            new_arr.push(sum_of_days);
            sum_of_days = 0;
        }

        count_of_day_arr = new_arr;


        Array.prototype.each_slice = function( size, callback ) {
            var j = 0;
            for ( var i = 0, l = this.length; i < l; ) {
                callback.call(this, this.slice(i, i + size[j]));
                i += size[j];
                j++;
            }
        };

        var avarage;
        if ( flag ) {
            /*Count!*/
            avarage = 0;
            if (separated) {
                var values_arr = [];
                values.map( function (value) {
                    value.each_slice(count_of_day_arr, function( sub_array ) {
                        $.each(sub_array, function() {
                            avarage += this;
                        });

                        values_arr.push(avarage);
                        avarage = 0;
                    });
                } );
            }
            else {
                values.each_slice(count_of_day_arr, function( sub_array ) {
                    $.each(sub_array, function() {
                        avarage += this;
                    });

                    values_arr.push(avarage);
                    avarage = 0;
                });
            }

            /*Month!*/
            dates.each_slice(count_of_day_arr, function( sub_array ) {
                dates_arr.push(sub_array[0]);
            });

        } else {
              //  some_digit =>  Начинаем обрезать с "1" так как нам не нужен последний месяц ( декабрь ) а нужен ( июнь ) .. в примере когда конечная дата декабрь!
            //             =>  Но если заданная дата больше чем кол-во днейв предидущем месяце - то берем с "0" так как нам нуже декабрь , а не июнь в примере
            //   UPD. вроде как нужно только при работе с одним месяцем ( range = 1 month )

            var some_digit = 0;
            if ( count_of_day_arr[1] > to_date_day ) {
            some_digit = 1;
            }

            if ( count_of_month > 1 ) {
            some_digit = 0
            }


            var cuted_array = count_of_day_arr.slice(some_digit, 7 + some_digit);

            cuted_array.reverse();


            /*Count!*/
            avarage = 0;
            var total = eval(cuted_array.join('+'));
            if (separated) {
                values = values.map( function (value) {
                 return value.reverse().slice(0, total).reverse();
                 } );
            }
            else { values.reverse().slice(0, total).reverse(); }
            dates = dates.reverse().slice(0, total).reverse();

            if (separated) {
                values.map( function (value) {
                    value.each_slice(cuted_array, function( sub_array ) {
                        $.each(sub_array, function() {
                            avarage += this;
                        });

                        values_arr.push(avarage);
                        avarage = 0;
                    });
                } );
            }
            else {
                values.each_slice(cuted_array, function( sub_array ) {
                    $.each(sub_array, function() {
                        avarage += this;
                    });

                values_arr.push(avarage);
                avarage = 0;
            });
        }


        /*Month!*/

        dates.each_slice(cuted_array, function( sub_array ) {
        dates_arr.push(sub_array[0]);
        });
        }


        dates = dates_arr;
        if (separated) {
            var j=0;
             var val_array = [];
             values = values.map( function (value) {
                 val_array = values_arr.slice(j,j+7);
                 j+=7;
                 return val_array;
             } );
        }
        else {
            values = values_arr;
        }
    }

    function toDate( strDate ) {
        var args = strDate.split(' ');

        // for IE 8 => .map(Number) was removed
        args = $.map(args, function( x ) {
            return Number(x);
        });


        args[1] = args[1] - 1;
        return Date.UTC.apply(Date, args);
    }
    var series_chart = [];
    if (separated) {
        var departments = $("#department_id").val();
        var i=0;
        values.map( function (value) {
            var output_arr = [];
            for ( var j = 0, length = dates.length; j < length; j += 1 ) {
                output_arr[j] = {
                    x: toDate(dates[j]),
                    y: value[j]
                };
            }
            series_chart.push({ name: "department " + departments[i].toString(), data: output_arr });
            i++;
        } );
    }

    else {
        var output_arr = [];
        for ( var j = 0, length = dates.length; j < length; j += 1 ) {
            output_arr[j] = {
                x: toDate(dates[j]),
                y: values[j]
            };
        }
        series_chart.push({ name: "Visits", data: output_arr });
    }


    chart = new Highcharts.Chart({
        chart: {
            renderTo: 'container',
            type: 'line',
            marginRight: 130,
            marginBottom: 25
        },
        title: {
            text: 'Line - Graph',
            x: -20 //center
        },
        subtitle: {
            text: '',
            x: -20
        },
        xAxis: {
            type: 'datetime',

            dateTimeLabelFormats: {
                hour: '%H:%M',
                day: '%e %b',
                week: '%e %b',
                month: '%b %Y',
                year: '%b %Y'
            }
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Page views'
            },
            plotLines:
            [
                {
                    value: 0,
                    width: 1,
                    color: '#808080'
                }
            ]
        },
        tooltip: {
            formatter: function() {
                return '<b>' + this.series.name + '</b><br/>' +
                Highcharts.dateFormat("%e %b %Y", this.x) + ': ' + Math.round(this.y).toFixed(1);
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: -10,
            y: 100,
            borderWidth: 0
        },
        series: series_chart
    });
}

function setup_graph_screen_2(report_day_date, report_day_array, pie_graph_view_data, pie_sum_totals){
    var chart;
    chart = new Highcharts.Chart({
        chart: {
            renderTo: 'container',
            type: 'column'
        },
        title: {
            text: 'Column graph'
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            categories: report_day_date
        },
        yAxis: {
            min: 0,
            title: {
                text: ''
            }
        },
        legend: {
            layout: 'vertical',
            backgroundColor: '#FFFFFF',
            align: 'left',
            verticalAlign: 'top',
            x: 100,
            y: 70,
            floating: true,
            shadow: true
        },
        tooltip: {
            formatter: function() {
                return '' +
                this.x + ': ' + this.y + ' Visits';
            }
        },
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0
            }
        },
        series: [
            {
                name: 'Visits',
                data: report_day_array
            }
        ]
    });
    chart = new Highcharts.Chart({
        chart: {
            renderTo: 'bar_container_graph',
            type: 'bar'
        },
        title: {
            text: 'Bar graph'
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            categories: report_day_date
        },
        yAxis: {
            min: 0,
            title: {
                text: ''
            }
        },
        legend: {
            layout: 'vertical',
            backgroundColor: '#FFFFFF',
            align: 'left',
            verticalAlign: 'top',
            x: 100,
            y: 70,
            floating: true,
            shadow: true
        },
        tooltip: {
            formatter: function() {
                return '' +
                this.x + ': ' + this.y + ' Visits';
            }
        },
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0
            }
        },
        series: [
            {
                name: 'Visits',
                data: report_day_array
            }
        ]
    });
    if (pie_sum_totals > 0) {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'pie_container_graph',
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'Pie graph'
            },
            tooltip: {
                formatter: function() {
                    return '<b>' + this.point.name + '</b>: ' + this.percentage.toFixed(2) + ' %';
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function() {
                            return '<b>' + this.point.name + '</b>: ' + this.percentage.toFixed(2) + ' %';
                        }
                    }
                }
            },
            series: [
                {
                    type: 'pie',
                    name: 'Visits in %',
                    data: pie_graph_view_data
                }
            ]
        });
    }
}

