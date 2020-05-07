var input = document.getElementById("pin");
var dirty = false;

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
	(new HttpClient()).get(base_url + pin, function(response) {
		response = JSON.parse(response);
		if (response.includes("kahoot")) {
			response = response["kahoot"]["questions"];
			var real = [];
			for (var i = 0; i < response.length; i++) { // Question
				for (var j = 0; j < response[i].length; j++) { // Answers
					if (response[i][j]["correct"]) { // Correct?
						real.push([response[i]["question"], response[i][j]["answer"]]);
					}
				}
			}
			tableCreate(results);
		} else {
			error();
			return;
		}
	});
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

var HttpClient = function() {
    this.get = function(aUrl, aCallback) {
        var anHttpRequest = new XMLHttpRequest();
        anHttpRequest.onreadystatechange = function() { 
            if (anHttpRequest.readyState == 4 && anHttpRequest.status == 200)
                aCallback(anHttpRequest.responseText);
        }

        anHttpRequest.open( "GET", aUrl, true );            
        anHttpRequest.send( null );
    }
}
