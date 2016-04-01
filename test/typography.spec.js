
import addElement from './util/add-element'

describe('typography', () => {

  const container = addElement('div')
  const h1 = addElement('h1', container)
  const p = addElement('p', container)
  const ul = addElement('ul', container)
  const a = addElement('a', container)

  container.style.fontFamily = 'Helvetica'
  container.style.fontSize = '32px'

  it('should set font-family inherit', () => {
    p.className = 'font-family-inherit'
    expect(p.computedStyle.fontFamily).to.equal('Helvetica')
  })

  it('should set font-size inherit', () => {
    p.className = 'font-size-inherit'
    expect(p.computedStyle.fontSize).to.equal('32px')
  })

  it('should set text-decoration none', () => {
    a.className = 'text-decoration-none'
    expect(a.computedStyle.textDecoration).to.equal('none')
  })

  it('should set font-weight bold', () => {
    p.className = 'bold'
    expect(p.computedStyle.fontWeight).to.match(/bold|700/)
  })

  it('should set font-weight normal', () => {
    h1.className = 'regular'
    expect(h1.computedStyle.fontWeight).to.match(/normal|400/)
  })

  it('should set font-style italic', () => {
    h1.className = 'italic'
    expect(h1.computedStyle.fontStyle).to.equal('italic')
  })

  it('should set uppercase and add tracking', () => {
    h1.className = 'caps'
    expect(h1.computedStyle.textTransform).to.equal('uppercase')
    expect(h1.computedStyle.letterSpacing).to.not.equal('normal')
  })

  it('should left align text', () => {
    h1.className = 'left-align'
    expect(h1.computedStyle.textAlign).to.equal('left')
  })

  it('should center align text', () => {
    h1.className = 'center'
    expect(h1.computedStyle.textAlign).to.equal('center')
  })

  it('should right align text', () => {
    h1.className = 'right-align'
    expect(h1.computedStyle.textAlign).to.equal('right')
  })

  it('should justify text', () => {
    h1.className = 'justify'
    expect(h1.computedStyle.textAlign).to.equal('justify')
  })

  it('should set white-space nowrap', () => {
    h1.className = 'nowrap'
    expect(h1.computedStyle.whiteSpace).to.equal('nowrap')
  })

  it('should set word-wrap break-word', () => {
    h1.className = 'break-word'
    expect(h1.computedStyle.wordWrap).to.equal('break-word')
  })

  it('should set line-height 1', () => {
    h1.className = 'line-height-1'
    expect(h1.computedStyle.lineHeight).to.equal('64px')
  })

  it('should set line-height 1.125', () => {
    h1.className = 'line-height-2'
    expect(h1.computedStyle.lineHeight).to.equal('72px')
  })

  it('should set line-height 1.25', () => {
    h1.className = 'line-height-3'
    expect(h1.computedStyle.lineHeight).to.equal('80px')
  })

  it('should set line-height 1.5', () => {
    h1.className = 'line-height-4'
    expect(h1.computedStyle.lineHeight).to.equal('96px')
  })

  it('should set list-style none', () => {
    ul.className = 'list-style-none'
    expect(ul.computedStyle.listStyle).to.match(/none|^$/)
  })

  it('should set text-decoration underline', () => {
    h1.className = 'underline'
    expect(h1.computedStyle.textDecoration).to.equal('underline')
  })

  it('should truncate text', () => {
    h1.className = 'truncate'
    expect(h1.computedStyle.overflow).to.equal('hidden')
    expect(h1.computedStyle.textOverflow).to.equal('ellipsis')
    expect(h1.computedStyle.whiteSpace).to.equal('nowrap')
  })

  it('should reset list style', () => {
    ul.className = 'list-reset'
    expect(ul.computedStyle.listStyle).to.match(/none|^$/)
    expect(ul.computedStyle.paddingLeft).to.match(/0px|^$/)
  })

})
