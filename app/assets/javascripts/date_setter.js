// @ts-nocheck
// ^ Enables ts type checking in js files

/**
 * @param {HTMLInputElement} elem
 */
function setToToday(elem) {
  elem.valueAsDate = new Date();
}

/**
 * @param {Object} [param0]
 * @param {string} param0.selector
 * @param {(arg0: HTMLInputElement) => void} param0.setter
 */
function enableDateSetting({
  selector = "input[type=date]",
  setter = setToToday,
} = {}) {
  for (const date_elem of $(selector)) {
    date_elem.addEventListener("focus", (/** @type {FocusEvent}} */ ev) => {
      /** type {HTMLInputElement} */
      const elem = ev.target;
      if (!elem?.value) {
        setter(elem);
      }
    });
  }
}
