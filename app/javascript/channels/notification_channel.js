import consumer from "./consumer"

let currentSubscription;
document.addEventListener('turbolinks:load', () => {

  if (currentSubscription ){
    consumer.subscriptions.remove(currentSubscription);
  }
  
  currentSubscription=consumer.subscriptions.create({ channel: "NotificationChannel", user_id: $('#side-list').attr('user_id') }, {
    connected() {
      // Called when the subscription is ready for use on the server
      
      console.log("connected data")
     
    },
  
    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log("Disconnected data")
    },
  
    received(data){ 
      let count=Number($('#notification-count').text())
      $('#notification-count').text(count+1)
      $('#notification-list').append(`<a href="${data.path}" style="text-decoration: none; color: black;"> <li>
      <div class="card">
        <div class="card-body">
          <p class="card-text">${data.message}</p>
        </div>
      </div>
    </li></a>`)
      $('#mark-as-read').removeClass('d-none')
      $('#empty_notification').addClass('d-none')
    }
  });
});
