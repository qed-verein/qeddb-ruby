document.addEventListener("DOMContentLoaded", () =>
  document.querySelectorAll("select.slim-select").forEach((it) => {
    console.log(it);
    new SlimSelect({
      select: it,
      settings: {
        searchText: it.dataset.selectSearchNonFound ?? "Nichts gefunden",
        searchPlaceholder: it.dataset.selectSearchPlaceholder ?? "Suchen",
      },
    });
  }),
);
