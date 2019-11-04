

/* draw circle on mini canvas based on gaze position */
function drawCircle(x, y, r, color) {
    
    const Elbody = document.querySelector('body');
    var canvasEl = document.createElement('canvas');
    canvasEl.style.position = 'absolute';
    canvasEl.style.left = (x-r).toString() + "px"
    canvasEl.style.top = (y-r).toString() + "px"
    canvasEl.width = r * 2
    canvasEl.height = r * 2
    canvasEl.style.zIndex = 1000;

    Elbody.insertBefore(canvasEl, Elbody.firstChild);

    var ctx = canvasEl.getContext("2d");
    ctx.globalAlpha = 0.5;
    ctx.beginPath();
    ctx.arc(r,r,r,0,2*Math.PI);
    ctx.fillStyle = color; //"#00AA00";
    ctx.fill();
    //ctx.stroke();
}

//drawCircle(100, 100, 30, "#CC0000")
