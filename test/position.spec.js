
describe('position', () => {

  const addElement = (el) => {
    const $el = document.createElement(el)
    document.body.appendChild($el)
    $el.computedStyle = window.getComputedStyle($el)
    return $el
  }

  const div = addElement('div')

  it('should set position relative', () => {
    div.className = 'relative'
    expect(div.computedStyle.position).to.equal('relative')
  })

  it('should set position absolute', () => {
    div.className = 'absolute'
    expect(div.computedStyle.position).to.equal('absolute')
  })

  it('should set position fixed', () => {
    div.className = 'fixed'
    expect(div.computedStyle.position).to.equal('fixed')
  })

  it('should set top 0', () => {
    div.className = 'top-0'
    expect(div.computedStyle.top).to.equal('0px')
  })

  it('should set right 0', () => {
    div.className = 'right-0'
    expect(div.computedStyle.right).to.equal('0px')
  })

  it('should set bottom 0', () => {
    div.className = 'bottom-0'
    expect(div.computedStyle.bottom).to.equal('0px')
  })

  it('should set left 0', () => {
    div.className = 'left-0'
    expect(div.computedStyle.left).to.equal('0px')
  })

  it('should set z-index 1', () => {
    div.className = 'z1'
    expect(div.computedStyle.zIndex).to.equal('1')
  })

  it('should set z-index 2', () => {
    div.className = 'z2'
    expect(div.computedStyle.zIndex).to.equal('2')
  })

  it('should set z-index 3', () => {
    div.className = 'z3'
    expect(div.computedStyle.zIndex).to.equal('3')
  })

  it('should set z-index 4', () => {
    div.className = 'z4'
    expect(div.computedStyle.zIndex).to.equal('4')
  })

})
