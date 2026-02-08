document.addEventListener("DOMContentLoaded", () =>
  document.querySelectorAll("select.slim-select").forEach((it) => {
    new SlimSelect({
      select: it,
      settings: {
        searchText: it.dataset.selectSearchNonFound ?? "Nichts gefunden",
        searchPlaceholder: it.dataset.selectSearchPlaceholder ?? "Suchen",
      },
    });
  }),
);
