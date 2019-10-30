




const Elbody = document.querySelector('body');
var canvasEl = document.createElement('canvas');
canvasEl.style.position = 'absolute';
canvasEl.style.top = "100px"
canvasEl.style.left = "50px"
canvasEl.width = 20
canvasEl.height = 20
canvasEl.style.zIndex = 1000;

Elbody.insertBefore(canvasEl, Elbody.firstChild);

var c = canvasEl;
var ctx = canvasEl.getContext("2d");

ctx.beginPath();
ctx.arc(10,10,5,0,2*Math.PI);
ctx.stroke();




