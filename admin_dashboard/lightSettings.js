$(function () {
	var rangePercent = $('[type="range"]').val();
	$('[type="range"]').on("change input", function () {
		rangePercent = $('[type="range"]').val();
		$("h4").html(rangePercent + "<span></span>");
		$('[type="range"], h4>span').css(
			"filter",
			"hue-rotate(-" + rangePercent + "deg)"
		);
		// $('h4').css({'transform': 'translateX(calc(-50% - 20px)) scale(' + (1+(rangePercent/100)) + ')', 'left': rangePercent+'%'});
		$("h4").css({
			transform: "translateX(-50%) scale(" + (1 + rangePercent / 100) + ")",
			left: rangePercent + "%"
		});
	});
});


let input = document.querySelector("input")
let button = document.querySelector("button")

input.addEventListener("change", ()=>{
    number = Math.round(input.value*2.55);
    const data = { ledEnergy: number };
    console.log(number)

    fetch('https://us-central1-smartkarabakh.cloudfunctions.net/main/main/setLedData', {
      method: 'POST', 
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    })
    .then(response => response.json())
    .then(data => {
      console.log('Success:', data);
    })
    .catch((error) => {
      console.error('Error:', error);
    });
})


