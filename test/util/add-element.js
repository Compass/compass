
const addElement = (el, parent) => {
  const $el = document.createElement(el)
  parent = parent || document.body
  parent.appendChild($el)
  $el.computedStyle = window.getComputedStyle($el)
  return $el
}

export default addElement

