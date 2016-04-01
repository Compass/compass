
import addElement from './util/add-element'

describe('border', () => {

  const div = addElement('div')
  const input = addElement('input')

  div.style.width = '32px'
  div.style.height = '32px'

  it('should apply border style', () => {
    div.className = 'border'
    expect(div.computedStyle.borderTopStyle).to.equal('solid')
    expect(div.computedStyle.borderRightStyle).to.equal('solid')
    expect(div.computedStyle.borderBottomStyle).to.equal('solid')
    expect(div.computedStyle.borderLeftStyle).to.equal('solid')
  })

  it('should apply border width', () => {
    div.className = 'border'
    expect(div.computedStyle.borderTopWidth).to.equal('1px')
    expect(div.computedStyle.borderRightWidth).to.equal('1px')
    expect(div.computedStyle.borderBottomWidth).to.equal('1px')
    expect(div.computedStyle.borderLeftWidth).to.equal('1px')
  })

  it('should apply border top styles', () => {
    div.className = 'border-top'
    expect(div.computedStyle.borderTopWidth).to.equal('1px')
    expect(div.computedStyle.borderTopStyle).to.equal('solid')
  })

  it('should apply border right styles', () => {
    div.className = 'border-right'
    expect(div.computedStyle.borderRightWidth).to.equal('1px')
    expect(div.computedStyle.borderRightStyle).to.equal('solid')
  })

  it('should apply border bottom styles', () => {
    div.className = 'border-bottom'
    expect(div.computedStyle.borderBottomWidth).to.equal('1px')
    expect(div.computedStyle.borderBottomStyle).to.equal('solid')
  })

  it('should apply border left styles', () => {
    div.className = 'border-left'
    expect(div.computedStyle.borderLeftWidth).to.equal('1px')
    expect(div.computedStyle.borderLeftStyle).to.equal('solid')
  })

  it('should remove border styles', () => {
    input.className = 'border-none'
    expect(input.computedStyle.borderTopWidth).to.match(/0px|^$/)
  })

  it('should apply border radius', () => {
    div.className = 'rounded'
    expect(div.computedStyle.borderTopRightRadius).to.equal('3px')
  })

  it('should apply circular border radius', () => {
    div.className = 'circle'
    expect(div.computedStyle.borderTopRightRadius).to.match(/16px|50\%/)
  })

  it('should apply directional border radii', () => {
    div.className = 'rounded-top'
    expect(div.computedStyle.borderTopRightRadius).to.equal('3px')
    expect(div.computedStyle.borderBottomRightRadius).to.equal('0px')
  })

})
