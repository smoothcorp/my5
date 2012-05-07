$(document).ready () ->
  
  quick_tips = ["Good hydration can help enhance your mental clarity, so help keep yourself alert all day and drink water.", 
    "Good hydration can help benefit your joints and help lessen back discomfort and pain.", 
    "Relaxed breathing into your abdomen can help to relax muscles and relieve tension.", 
    "Remember to breathe! It can help reduce mental and physical fatigue.",
    "Good posture! Remember to sit up with a lengthened spine and relaxed shoulders throughout the day.", 
    "Get up and move! Even a little exercise can help boost your mood, relieve stress and boost your energy."]
  
  doInterval = setInterval(() -> 
    quick_tips_elem = $("#quick-tips ul")
    firstRandomNumber = Math.floor(Math.random()*quick_tips.length)
    secondRandomNumber = Math.floor(Math.random()*quick_tips.length)
    secondRandomNumber = Math.floor(Math.random()*quick_tips.length) while (secondRandomNumber == firstRandomNumber)
    quick_tips_elem.text('').append($("<li></li>").text(quick_tips[firstRandomNumber])) 
    #.append($("<li></li>").text(quick_tips[secondRandomNumber]))
  , 10000);
  