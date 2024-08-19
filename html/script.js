function updateStatusBars(health, armor, hunger, thirst) {
  document.querySelector(".health .bar-fill").style.width = `${health}%`;
  document.querySelector(".armor .bar-fill").style.width = `${armor}%`;
  document.querySelector(".hunger .bar-fill").style.width = `${hunger}%`;
  document.querySelector(".thirst .bar-fill").style.width = `${thirst}%`;
}

function updateSpeedometer(speed) {
  const speedValueElem = document.querySelector('.speed-value');

  speedValueElem.textContent = Math.round(speed);
}

function toggleSpeedometer(visible) {
  const speedometer = document.getElementById('speedometer');
  if (visible) {
      speedometer.style.display = 'flex';
  } else {
      speedometer.style.display = 'none';
  }
}


document.addEventListener("DOMContentLoaded", function () {
  const usernameTextElem = document.getElementById("username-text");
  const clockElem = document.getElementById("clock");
  const moneyElem = document.getElementById("money");

  window.addEventListener("message", function (event) {
    var date = new Date();
    if (event.data.type === "hudUpdate") {
      usernameTextElem.textContent = `${event.data.username} | ${event.data.job} | ID: ${event.data.id}`;

      clockElem.textContent = ("0" + date.getHours()).slice(-2) + ":" + ("0" + date.getMinutes()).slice(-2);

      moneyElem.textContent = `$${event.data.money.toString().padStart(9, "0")}`;

      updateStatusBars(
        event.data.health,
        event.data.armor,
        event.data.hunger,
        event.data.thirst
      );
    }
    else if (event.data.type === "speedUpdate") {
      toggleSpeedometer(event.data.isInVehicle);
      updateSpeedometer(event.data.speed);
  }
  });
});
