
import addElement from './util/add-element'

describe('align', () => {

  const div = addElement('div')

  it('should set vertical-align baseline', () => {
    div.className = 'inline-block align-baseline'
    expect(div.computedStyle.verticalAlign).to.equal('baseline')
  })

  it('should set vertical-align top', () => {
    div.className = 'inline-block align-top'
    expect(div.computedStyle.verticalAlign).to.equal('top')
  })

  it('should set vertical-align middle', () => {
    div.className = 'inline-block align-middle'
    expect(div.computedStyle.verticalAlign).to.equal('middle')
  })

  it('should set vertical-align bottom', () => {
    div.className = 'inline-block align-bottom'
    expect(div.computedStyle.verticalAlign).to.equal('bottom')
  })

})

