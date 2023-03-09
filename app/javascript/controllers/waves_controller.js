import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const init = () => {
      const ctx = this.element.getContext("2d");
      ctx.canvas.width = getComputedStyle(this.element).width.replace(/[a-z]/g, '');
      ctx.canvas.height = getComputedStyle(this.element).height.replace(/[a-z]/g, '');
      const ovals = [];
      const maxAmount = 5;
      const overlayColor = this.element.dataset.color;
    
      for (let i = 0; i < maxAmount; i++) {
        ovals.push(generateOval(ctx, true));
      }
      window.requestAnimationFrame(() => draw(ovals, ctx, maxAmount, overlayColor));
    };
    
    const draw = (ovals, ctx, maxAmount, overlayColor) => {
      ctx.globalAlpha = 1
      ctx.clearRect(0, 0, ctx.canvas.offsetWidth, ctx.canvas.offsetHeight);
      ctx.fillStyle = "#f1f1f1";
      ctx.fillRect(0, 0, ctx.canvas.offsetWidth, ctx.canvas.offsetHeight);
    
      for (let i = 0; i < ovals.length; i++) {
        const oval = ovals[i];
        ctx.beginPath();
        ctx.ellipse(oval.x - oval.relativeStart, oval.y, oval.width, oval.height, Math.PI, 0, 2 * Math.PI);
        ctx.fillStyle = overlayColor;
        ctx.globalAlpha = 0.3
        ctx.fill()
        ovals[i]["x"] = ovals[i]["x"] += 1.5 * oval.speedModifier
        ovals[i]["y"] = ovals[i]["y"] += 0.1 * oval.angle
    
        if (oval.x > ctx.canvas.offsetWidth / 2 + 50 && !oval.hasPropagated) {
          ovals.push(generateOval(ctx, false))
          ovals[i]['hasPropagated'] = true
        }
    
        if (ovals[i]["x"] - ovals[i]["width"] * 2 > ctx.canvas.offsetWidth * 2)  {
          if (ovals.length > maxAmount * 4) {
            ovals.splice(0, 1)
          }
        }
      }
    
      window.requestAnimationFrame(() => draw(ovals, ctx, maxAmount, overlayColor));
    };
    
    const generateOval = (ctx, first) => {
      const height = (Math.random() * (ctx.canvas.offsetHeight) + 100) + 120
      return {
        x: first ? (Math.random() * (ctx.canvas.offsetWidth - ctx.canvas.offsetWidth / 1.5) + ctx.canvas.offsetWidth / 1.5) : ctx.canvas.offsetWidth * -1,
        y: height / 12 + ctx.canvas.offsetHeight,
        // ctx.canvas.offsetHeight + Math.random() * (180 - 120) + 120
        relativeStart: Math.random() * (ctx.canvas.offsetWidth - 200) + 200,
        width: height * 1.5,
        height: height,
        color: this.element.dataset.color,
        hasPropagated: false,
        speedModifier: Math.floor(Math.random() * 2),
        angle: Math.floor(Math.random() * (2 - 1 + 1)) + 1 * (Math.random() > 0.5 ? -1 : 1)
      }
    }
    
    init();
    
    window.addEventListener('resize', event => {
      init();
    })
  }
}
