var input = document.getElementById("pin");
var dirty = false;

function error() {
	alert("Error!");
}


// Execute a function when the user releases a key on the keyboard
input.addEventListener("keyup", function(event) {
  // Number 13 is the "Enter" key on the keyboard
  if (event.keyCode === 13) {
    // Cancel the default action, if needed
    event.preventDefault();
    // Trigger the button element with a click
    document.getElementById("check").click();
  }
});

var base_url = "https://kahoot.it/rest/challenges/pin/";

function check() {
	if (dirty) {
		location.reload();
	}
	var pin = document.getElementById("pin").value;
	if (pin.length != 6) {
		error();
		return;
	}

	var frame = document.getElementById("frame");
	frame.src = base_url + pin;
	data = JSON.parse(frame.value);

	if (data.includes("kahoot")) {
		data = data["kahoot"]["questions"];
		var real = [];
		for (var i = 0; i < data.length; i++) { // Question
			for (var j = 0; j < data[i].length; j++) { // Answers
				if (data[i][j]["correct"]) { // Correct?
					real.push([data[i]["question"], data[i][j]["answer"]]);
				}
			}
		}
		tableCreate(results);
	} else {
		error();
		return;
	}
	return;
}

function tableCreate(results) {
  var body = document.getElementsByTagName('body')[0];
  var tbl = document.createElement('table');
  tbl.style.width = '100%';
  tbl.setAttribute('border', '1');
  var tbdy = document.createElement('tbody');
  for (var i = 0; i < 3; i++) {
    var tr = document.createElement('tr');
    for (var j = 0; j < 2; j++) {
      if (i == 2 && j == 1) {
        break
      } else {
        var td = document.createElement('td');
        td.appendChild(document.createTextNode(results.pop()))
        i == 1 && j == 1 ? td.setAttribute('rowSpan', '2') : null;
        tr.appendChild(td)
      }
    }
    tbdy.appendChild(tr);
  }
  tbl.appendChild(tbdy);
  body.appendChild(tbl)
}
