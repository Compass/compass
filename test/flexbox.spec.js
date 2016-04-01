
import addElement from './util/add-element'

describe('flexbox', () => {

  const div = addElement('div')

  it('should set display flex', () => {
    div.className = 'flex'
    expect(div.computedStyle.display).to.equal('flex')
  })

  it('should set flex-direction', () => {
    div.className = 'flex-column'
    expect(div.computedStyle.flexDirection).to.equal('column')
  })

  it('should set flex-wrap', () => {
    div.className = 'flex-wrap'
    expect(div.computedStyle.flexWrap).to.equal('wrap')
  })

  it('should set align-items flex-start', () => {
    div.className = 'items-start'
    expect(div.computedStyle.alignItems).to.equal('flex-start')
  })

  it('should set align-items flex-end', () => {
    div.className = 'items-end'
    expect(div.computedStyle.alignItems).to.equal('flex-end')
  })

  it('should set align-items center', () => {
    div.className = 'items-center'
    expect(div.computedStyle.alignItems).to.equal('center')
  })

  it('should set align-items baseline', () => {
    div.className = 'items-baseline'
    expect(div.computedStyle.alignItems).to.equal('baseline')
  })

  it('should set align-items stretch', () => {
    div.className = 'items-stretch'
    expect(div.computedStyle.alignItems).to.equal('stretch')
  })

  it('should set align-self flex-start', () => {
    div.className = 'self-start'
    expect(div.computedStyle.alignSelf).to.equal('flex-start')
  })

  it('should set align-self flex-end', () => {
    div.className = 'self-end'
    expect(div.computedStyle.alignSelf).to.equal('flex-end')
  })

  it('should set align-self center', () => {
    div.className = 'self-center'
    expect(div.computedStyle.alignSelf).to.equal('center')
  })

  it('should set align-self baseline', () => {
    div.className = 'self-baseline'
    expect(div.computedStyle.alignSelf).to.equal('baseline')
  })

  it('should set align-self stretch', () => {
    div.className = 'self-stretch'
    expect(div.computedStyle.alignSelf).to.equal('stretch')
  })

  it('should set justify-content flex-start', () => {
    div.className = 'justify-start'
    expect(div.computedStyle.justifyContent).to.equal('flex-start')
  })

  it('should set justify-content flex-end', () => {
    div.className = 'justify-end'
    expect(div.computedStyle.justifyContent).to.equal('flex-end')
  })

  it('should set justify-content center', () => {
    div.className = 'justify-center'
    expect(div.computedStyle.justifyContent).to.equal('center')
  })

  it('should set justify-content space-between', () => {
    div.className = 'justify-between'
    expect(div.computedStyle.justifyContent).to.equal('space-between')
  })

  it('should set justify-content space-around', () => {
    div.className = 'justify-around'
    expect(div.computedStyle.justifyContent).to.equal('space-around')
  })

  it('should set align-content flex-start', () => {
    div.className = 'content-start'
    expect(div.computedStyle.alignContent).to.equal('flex-start')
  })

  it('should set align-content flex-end', () => {
    div.className = 'content-end'
    expect(div.computedStyle.alignContent).to.equal('flex-end')
  })

  it('should set align-content center', () => {
    div.className = 'content-center'
    expect(div.computedStyle.alignContent).to.equal('center')
  })

  it('should set align-content space-between', () => {
    div.className = 'content-between'
    expect(div.computedStyle.alignContent).to.equal('space-between')
  })

  it('should set align-content space-around', () => {
    div.className = 'content-around'
    expect(div.computedStyle.alignContent).to.equal('space-around')
  })

  it('should set align-content stretch', () => {
    div.className = 'content-stretch'
    expect(div.computedStyle.alignContent).to.equal('stretch')
  })

  it('should set flex to 1 1 auto', () => {
    div.className = 'flex-auto'
    expect(div.computedStyle.flexGrow).to.equal('1')
    expect(div.computedStyle.flexShrink).to.equal('1')
    expect(div.computedStyle.flexBasis).to.equal('auto')
  })

  it('should set flex none', () => {
    div.className = 'flex-none'
    expect(div.computedStyle.flexGrow).to.equal('0')
    expect(div.computedStyle.flexShrink).to.equal('0')
    expect(div.computedStyle.flexBasis).to.equal('auto')
  })

  it('should set order 0', () => {
    div.className = 'order-0'
    expect(div.computedStyle.order).to.equal('0')
  })

  it('should set order 1', () => {
    div.className = 'order-1'
    expect(div.computedStyle.order).to.equal('1')
  })

  it('should set order 2', () => {
    div.className = 'order-2'
    expect(div.computedStyle.order).to.equal('2')
  })

  it('should set order 3', () => {
    div.className = 'order-3'
    expect(div.computedStyle.order).to.equal('3')
  })

  it('should set order 99999', () => {
    div.className = 'order-last'
    expect(div.computedStyle.order).to.equal('99999')
  })

})

