
const bodyEl = document.querySelector('body');
const canvasEl = document.createElement('canvas');
canvasEl.style.position = 'absolute';
canvasEl.style.top = 0;
canvasEl.style.left = 0;
canvasEl.style.zIndex = 1000;

//canvasEl.width = 375;  // document.body.clientWidth;   // <-- will be called in other place
//canvasEl.height = 20000; //document.body.clientHeight; // <-- will be called in other place

bodyEl.insertBefore(canvasEl, bodyEl.firstChild);

var c = canvasEl;
var ctx = canvasEl.getContext("2d");


