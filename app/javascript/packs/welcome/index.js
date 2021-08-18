$(document).on("turbolinks:load", function() {
  console.log("[welcome]", "just work on initial loading page")
})


$(function() {
  console.log("[welcome]", "index")

  // welcome.json
  // welcome.js
  $.get({
    url: '/welcome.js',
    // data: { a: 2 },
    complete: function(data) {
      console.log(data)
    },
    timeout: 60000 });

  $(document).on("turbolinks:load", function() {
    console.log("not fired")
  })
})
