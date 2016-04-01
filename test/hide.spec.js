
import addElement from './util/add-element'

describe('hide', () => {

  const div = addElement('div')

  it('should accessibly hide', () => {
    div.className = 'hide'
    expect(div.computedStyle.position).to.equal('absolute')
    expect(div.computedStyle.height).to.equal('1px')
    expect(div.computedStyle.width).to.equal('1px')
    expect(div.computedStyle.overflow).to.equal('hidden')
    expect(div.computedStyle.clip).to.equal('rect(1px, 1px, 1px, 1px)')
  })

  it('should set display none', () => {
    div.className = 'display-none'
    expect(div.computedStyle.display).to.equal('none')
  })

  context('below sm breakpoint', () => {
    beforeEach(() => {
      // Resize window
    })

    it('should set display none for xs-hide')
    it('should not set display none for sm-hide')
    it('should not set display none for md-hide')
    it('should not set display none for lg-hide')
  })

  context('between sm and md breakpoint', () => {
    beforeEach(() => {
      // Resize window
    })

    it('should not set display none for xs-hide')
    it('should set display none for sm-hide')
    it('should not set display none for md-hide')
    it('should not set display none for lg-hide')
  })

  context('between md and lg breakpoint', () => {
    beforeEach(() => {
      // Resize window
    })

    it('should not set display none for xs-hide')
    it('should not set display none for sm-hide')
    it('should set display none for md-hide')
    it('should not set display none for lg-hide')
  })

  context('above lg breakpoint', () => {
    beforeEach(() => {
      // Resize window
    })

    it('should not set display none for xs-hide')
    it('should not set display none for sm-hide')
    it('should not set display none for md-hide')
    it('should set display none for lg-hide')
  })


})
