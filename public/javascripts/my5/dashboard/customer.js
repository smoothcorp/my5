/* DO NOT MODIFY. This file was compiled Mon, 28 Nov 2011 06:00:47 GMT from
 * /Users/chrishexton/Desktop/workspaces/rails/my5/app/coffeescripts/my5/dashboard/customer.coffee
 */


  $(document).ready(function() {
    var doInterval, quick_tips;
    quick_tips = ["Good hydration can help enhance your mental clarity, so help keep yourself alert all day and drink water.", "Good hydration can help benefit your joints and help lessen back discomfort and pain.", "Relaxed breathing into your abdomen can help to relax muscles and relieve tension.", "Remember to breathe! It can help reduce mental and physical fatigue.", "Good posture! Remember to sit up with a lengthened spine and relaxed shoulders throughout the day.", "Get up and move! Even a little exercise can help boost your mood, relieve stress and boost your energy."];
    return doInterval = setInterval(function() {
      var firstRandomNumber, quick_tips_elem, secondRandomNumber;
      quick_tips_elem = $("#quick-tips ul");
      firstRandomNumber = Math.floor(Math.random() * quick_tips.length);
      secondRandomNumber = Math.floor(Math.random() * quick_tips.length);
      while (secondRandomNumber === firstRandomNumber) {
        secondRandomNumber = Math.floor(Math.random() * quick_tips.length);
      }
      return quick_tips_elem.text('').append($("<li></li>").text(quick_tips[firstRandomNumber]));
    }, 10000);
  });
