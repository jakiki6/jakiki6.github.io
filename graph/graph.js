function drawLine(ctx, startX, startY, endX, endY){
    ctx.beginPath();
    ctx.moveTo(startX,startY);
    ctx.lineTo(endX,endY);
    ctx.stroke();
}

function draw() {
	var canvas = document.getElementById("canvas");
	var ctx = canvas.getContext("2d");
	ctx.fillStyle = "#FFFFFF";
	ctx.strokeStyle = "#000000";
	var form = document.getElementById("form").value;
	var maxX = document.getElementById("maxX").value;
	var minX = document.getElementById("minX").value;
	var step = document.getElementById("step").value;
	var minY = 0;
	var maxY = 0;
	var y = 0;
	for (var x = minX; x <= maxX; x = x + step) {
		eval(form);
		if (y > maxY) {
			maxY = y;
		}
		if (y < minY) {
			minY = y
		}
	}
	ctx.width = maxX + Math.abs(minX);
	ctx.height = maxY + Math.abs(minY);
	var px = minX;
	var py = minY;
	for (var x = minX; x <= maxX; x = x + step) {
		eval(form);
		drawLine(ctx, px, py, x, y);
		px = x;
		py = y;
	}
	alert("Done!");
}
