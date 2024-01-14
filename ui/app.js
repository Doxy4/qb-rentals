$(document).keyup(function(e) {
  if (e.key === "Escape") {
    $.post('https://qb-rentals/escape')
 }
});

function rentVehicle(name, price) {
  fetch("https://qb-rentals/rentvehicle", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      vehicleType: name,
      vehiclePrice: price,
    }),
  });
}

window.addEventListener("message", (event) => {
  let eventData = event.data;
  switch (eventData.type) {
    case "show": {
      if (eventData.enable) {

        if (eventData.nomoney) {

          const element = document.querySelector('.container');
          element.innerHTML += `
          <div class="moneyBox">You Dont Have Enough Money.</div>
          `
      
          setTimeout(function() {

            const elements = document.getElementsByClassName('moneyBox');

            for (let i = 0; i < elements.length; i++) {

              $(elements[i]).fadeOut(200);

            }

        }, 2500);

        } else {
        const element = document.querySelector('.wrapper');
        element.innerHTML = "";
        for (let i = 0; i < eventData.items.length; i++) {
          const data = eventData.items[i];
          dollarAmount = data.price
          let formattedAmount = dollarAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
          element.innerHTML += `

                  <div class="box">
                  <img class="img" src=${data.image} alt="">
                  <div class="price">$${formattedAmount} each minute</div>
                  <div class="title">${data.title}</div>
                  <button class="buy" onclick="rentVehicle('${data.name}','${data.price}')">
                    <span class="fas fa-cart-shopping"></span>
                    Rent Vehicle
                  </button>
                </div>
          `
        }

        $("body").fadeIn(0);     
        $(".rentals-container").slideDown(250);
      }
      } else {
        $("body").slideUp(250);
      } 
    }
  }
});