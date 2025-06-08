document.addEventListener("DOMContentLoaded", () => {
    const body = document.body;
    const navbar = document.querySelector(".navbar");
    const sidebar = document.getElementById("sidebar");
    const footer = document.querySelector("footer");
    const themeBtn = document.getElementById("themeToggle");
    const sidebarBtn = document.getElementById("sidebarToggle");

    // Theme: apply stored setting
    if (localStorage.getItem("theme") === "dark") {
      body.classList.add("dark-mode");
      navbar?.classList.add("dark-mode");
      sidebar?.classList.add("dark-mode");
      footer?.classList.add("dark-mode");
      themeBtn.innerHTML = '<i class="bi bi-sun"></i>';
    }

    // Sidebar: apply stored state only on desktop
    if (window.innerWidth >= 992 && localStorage.getItem("sidebar") === "collapsed") {
      body.classList.add("sidebar-collapsed");
    }

    // Theme toggle
    themeBtn?.addEventListener("click", () => {
      body.classList.toggle("dark-mode");
      navbar?.classList.toggle("dark-mode");
      sidebar?.classList.toggle("dark-mode");
      footer?.classList.toggle("dark-mode");

      const isDark = body.classList.contains("dark-mode");
      localStorage.setItem("theme", isDark ? "dark" : "light");
      themeBtn.innerHTML = isDark
        ? '<i class="bi bi-sun"></i>'
        : '<i class="bi bi-moon"></i>';
    });

    // Sidebar toggle
    sidebarBtn?.addEventListener("click", () => {
      if (window.innerWidth < 992) {
        body.classList.toggle("sidebar-open");
      } else {
        body.classList.toggle("sidebar-collapsed");
        const collapsed = body.classList.contains("sidebar-collapsed");
        localStorage.setItem("sidebar", collapsed ? "collapsed" : "expanded");
      }
    });

    // Auto-close sidebar on small screen click outside
    document.addEventListener("click", function (e) {
      if (window.innerWidth < 992 && body.classList.contains("sidebar-open")) {
        const isSidebar = sidebar.contains(e.target);
        const isToggle = sidebarBtn.contains(e.target);
        if (!isSidebar && !isToggle) {
          body.classList.remove("sidebar-open");
        }
      }
    });
  });