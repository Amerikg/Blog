const menuToggle = document.querySelector("[data-menu-toggle]");
const navigation = document.querySelector("#primary-navigation");

menuToggle?.addEventListener("click", () => {
  const isExpanded = menuToggle.getAttribute("aria-expanded") === "true";
  menuToggle.setAttribute("aria-expanded", String(!isExpanded));
  menuToggle.setAttribute("aria-label", isExpanded ? "Abrir menú" : "Cerrar menú");
  navigation?.classList.toggle("is-open", !isExpanded);
});