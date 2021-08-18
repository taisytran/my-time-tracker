// it will be fired
$(document).on("turbolinks:load", function() {
  console.log("[time sheet entries]", "just work on initial loading page")
})

// IIFE
$(function() {
  console.log("[time sheet entries]", "index")

  document.addEventListener("turbolinks:load", () => {
    console.log("not fired")
  })
})
