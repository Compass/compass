
import addElement from './util/add-element'

describe('margin', () => {

  const div = addElement('div')
  const h1 = addElement('h1')
  const ul = addElement('ul')

  describe('m0', () => {
    it('should set margin 0', () => {
      h1.className = 'm0'
      expect(h1.computedStyle.marginTop).to.equal('0px')
    })

    it('should set margin-top 0', () => {
      h1.className = 'mt0'
      expect(h1.computedStyle.marginTop).to.equal('0px')
    })

    it('should set margin-right 0', () => {
      h1.className = 'mr0'
      expect(h1.computedStyle.marginRight).to.equal('0px')
    })

    it('should set margin-bottom 0', () => {
      h1.className = 'mb0'
      expect(h1.computedStyle.marginBottom).to.equal('0px')
    })

    it('should set margin-left 0', () => {
      h1.className = 'ml0'
      expect(h1.computedStyle.marginLeft).to.equal('0px')
    })

    it('should set margin-left and margin-right 0', () => {
      h1.className = 'mx0'
      expect(h1.computedStyle.marginLeft).to.equal('0px')
      expect(h1.computedStyle.marginRight).to.equal('0px')
    })

    it('should set margin-top and margin-bottom 0', () => {
      h1.className = 'my0'
      expect(h1.computedStyle.marginTop).to.equal('0px')
      expect(h1.computedStyle.marginBottom).to.equal('0px')
    })
  })

  describe('m1', () => {
    it('should set margin 8px', () => {
      div.className = 'm1'
      expect(div.computedStyle.marginTop).to.equal('8px')
    })

    it('should set margin-top 8px', () => {
      div.className = 'mt1'
      expect(div.computedStyle.marginTop).to.equal('8px')
    })

    it('should set margin-right 8px', () => {
      div.className = 'mr1'
      expect(div.computedStyle.marginRight).to.equal('8px')
    })

    it('should set margin-bottom 8px', () => {
      div.className = 'mb1'
      expect(div.computedStyle.marginBottom).to.equal('8px')
    })

    it('should set margin-left 8px', () => {
      div.className = 'ml1'
      expect(div.computedStyle.marginLeft).to.equal('8px')
    })

    it('should set margin-left and margin-right 8px', () => {
      h1.className = 'mx1'
      expect(h1.computedStyle.marginLeft).to.equal('8px')
      expect(h1.computedStyle.marginRight).to.equal('8px')
    })

    it('should set margin-top and margin-bottom 8px', () => {
      h1.className = 'my1'
      expect(h1.computedStyle.marginTop).to.equal('8px')
      expect(h1.computedStyle.marginBottom).to.equal('8px')
    })
  })

  describe('m2', () => {
    it('should set margin 16px', () => {
      div.className = 'm2'
      expect(div.computedStyle.marginTop).to.equal('16px')
    })

    it('should set margin-top 16px', () => {
      div.className = 'mt2'
      expect(div.computedStyle.marginTop).to.equal('16px')
    })

    it('should set margin-right 16px', () => {
      div.className = 'mr2'
      expect(div.computedStyle.marginRight).to.equal('16px')
    })

    it('should set margin-bottom 16px', () => {
      div.className = 'mb2'
      expect(div.computedStyle.marginBottom).to.equal('16px')
    })

    it('should set margin-left 16px', () => {
      div.className = 'ml2'
      expect(div.computedStyle.marginLeft).to.equal('16px')
    })

    it('should set margin-left and margin-right 16px', () => {
      h1.className = 'mx2'
      expect(h1.computedStyle.marginLeft).to.equal('16px')
      expect(h1.computedStyle.marginRight).to.equal('16px')
    })

    it('should set margin-top and margin-bottom 16px', () => {
      h1.className = 'my2'
      expect(h1.computedStyle.marginTop).to.equal('16px')
      expect(h1.computedStyle.marginBottom).to.equal('16px')
    })
  })

  describe('m3', () => {
    it('should set margin 32px', () => {
      div.className = 'm3'
      expect(div.computedStyle.marginTop).to.equal('32px')
    })

    it('should set margin-top 32px', () => {
      div.className = 'mt3'
      expect(div.computedStyle.marginTop).to.equal('32px')
    })

    it('should set margin-right 32px', () => {
      div.className = 'mr3'
      expect(div.computedStyle.marginRight).to.equal('32px')
    })

    it('should set margin-bottom 32px', () => {
      div.className = 'mb3'
      expect(div.computedStyle.marginBottom).to.equal('32px')
    })

    it('should set margin-left 32px', () => {
      div.className = 'ml3'
      expect(div.computedStyle.marginLeft).to.equal('32px')
    })

    it('should set margin-left and margin-right 32px', () => {
      h1.className = 'mx3'
      expect(h1.computedStyle.marginLeft).to.equal('32px')
      expect(h1.computedStyle.marginRight).to.equal('32px')
    })

    it('should set margin-top and margin-bottom 32px', () => {
      h1.className = 'my3'
      expect(h1.computedStyle.marginTop).to.equal('32px')
      expect(h1.computedStyle.marginBottom).to.equal('32px')
    })
  })

  describe('m4', () => {
    it('should set margin 64px', () => {
      div.className = 'm4'
      expect(div.computedStyle.marginTop).to.equal('64px')
    })

    it('should set margin-top 64px', () => {
      div.className = 'mt4'
      expect(div.computedStyle.marginTop).to.equal('64px')
    })

    it('should set margin-right 64px', () => {
      div.className = 'mr4'
      expect(div.computedStyle.marginRight).to.equal('64px')
    })

    it('should set margin-bottom 64px', () => {
      div.className = 'mb4'
      expect(div.computedStyle.marginBottom).to.equal('64px')
    })

    it('should set margin-left 64px', () => {
      div.className = 'ml4'
      expect(div.computedStyle.marginLeft).to.equal('64px')
    })

    it('should set margin-left and margin-right 64px', () => {
      h1.className = 'mx4'
      expect(h1.computedStyle.marginLeft).to.equal('64px')
      expect(h1.computedStyle.marginRight).to.equal('64px')
    })

    it('should set margin-top and margin-bottom 64px', () => {
      h1.className = 'my4'
      expect(h1.computedStyle.marginTop).to.equal('64px')
      expect(h1.computedStyle.marginBottom).to.equal('64px')
    })
  })

  describe('auto', () => {
    it('should set margin-left auto')
    it('should set margin-right auto')
    it('should set margin-left and margin-right auto')
  })

})
