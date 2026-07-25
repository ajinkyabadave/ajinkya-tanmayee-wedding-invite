/* Light, dependency-free interactions.
   All motion is skipped when the user prefers reduced motion. */
(function () {
  "use strict";

  var reduce = window.matchMedia &&
    window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* ---- scroll reveal ---- */
  var reveals = document.querySelectorAll(".reveal");
  if (reduce || !("IntersectionObserver" in window)) {
    reveals.forEach(function (el) { el.classList.add("in"); });
  } else {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) {
          e.target.classList.add("in");
          io.unobserve(e.target);
        }
      });
    }, { threshold: 0.12 });
    reveals.forEach(function (el) { io.observe(el); });
    // Safety net: never leave content hidden (e.g. observer edge cases / screenshots).
    setTimeout(function () {
      reveals.forEach(function (el) { el.classList.add("in"); });
    }, 4000);
  }

  /* ---- floating petals ---- */
  if (!reduce) {
    var layer = document.querySelector(".petals");
    if (layer) {
      var glyphs = ["❀", "✿", "❁", "✤"]; // monochrome florets (take CSS color)
      var colors = ["#B4127A", "#C99A3B", "#E6C36B", "#8E0C60"];
      var COUNT = 14;
      for (var i = 0; i < COUNT; i++) {
        var p = document.createElement("span");
        p.className = "petal";
        p.textContent = glyphs[i % glyphs.length];
        p.style.left = (Math.floor((i / COUNT) * 100) + (i * 7) % 9) + "%";
        p.style.color = colors[i % colors.length];
        p.style.fontSize = (14 + (i % 5) * 4) + "px";
        p.style.animationDuration = (10 + (i % 7) * 2) + "s";
        p.style.animationDelay = "-" + ((i * 1.7) % 12) + "s";
        layer.appendChild(p);
      }
    }
  }
})();
