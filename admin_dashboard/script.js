let temperature = document.querySelector(".temperature-p")
let humidty = document.querySelector(".humidty-p")

let item;
let newSeries = [];
let newLabel = [];
let newArray = []

async function getApi() {
  await fetch("https://us-central1-smartkarabakh.cloudfunctions.net/main/main/getWeaterData")
    .then(res => res.json())
    .then(data => {
      data.map(item => {
        this.item = item;
        newSeries.push(item.t);
        newLabel.push(item.timestamp)
      })
      console.log(this.item)
      console.log(newLabel)
      temperature.innerHTML = `${this.item.t}` + " C"
      humidty.innerHTML = `${this.item.h}` + " %"
    })
}

getApi();


const ctx = document.getElementById('canvas');
const myChart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: newLabel,
    datasets: [{
      label: 'Temperature',
      data: newSeries,
      backgroundColor:
        "transparent"
      ,
      borderColor: "white",
      borderWidth: 4
    }]
  },
  options: {
    scales: {
      y: {
        beginAtZero: true
      }
    }
  }
});