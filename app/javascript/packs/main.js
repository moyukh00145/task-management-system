$('#change_pic').click(function(){
  console.log('clicked')
  $('#take_pic').trigger('click')
  $('#take_pic').on('change',function(e){
    if(e.target.files.length>0){
      $('#submit_btn').trigger('click');
    }
    
  })
})

$('#add-user').click(function(){
  $('#exampleModal').modal('show')
})
$('#add-user-container').click(function(){
  $('#exampleModal').modal('show')
})
$('#change-employee-details').click(function(){
  $('#exampleModal2').modal('show')
})

$('#add-user-to-db').click(function(){
  let _fname=$('#input-fname').val()
  let _lname=$('#input-lname').val()
  let _email=$('#input-email').val()
  let _roles=$('#input-roles').val()
  
  const user={
    fname:_fname,
    lname:_lname,
    email:_email,
    roles:Number(_roles)
  }

  add_user(user)

})

$('#add-admin-user-to-db').on('click', function (){
  let _fname=$('#input-fname-admin').val()
  let _lname=$('#input-lname-admin').val()
  let _email=$('#input-email-admin').val()
  let _pass=$('#input-pass-admin').val()

  if(check_admin_user_add_params(_fname,_lname,_email,_pass)){
    if(String(_email)
    .toLowerCase()
    .match(
      /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    )){

      const user={
        fname:_fname,
        lname:_lname,
        email:_email,
        password:_pass
      }
    
      $.ajax({
        url: '/superuser/add/adminuser',
        method: 'POST',
        data: { info: user, authenticity_token: $('meta[name="csrf-token"]').attr('content') },
        success: function(response) {
          if(response.status == true){
            alert('Successfully added admin user. Please log in to the system with that google account')
            window.location='/'
          }
          else{
            if (response.match==true){
              alert('Something error has occurred, Please try again')
            }
            if (response.match==false){
              alert('You are not authorized to Add admin User')
              $('#adminuser-pass-error').text('Not a Super Admin Password')
            }
          }
        },
        error: function(xhr, status, error) {
      
        }
        });
      
    }
    else{
      $('#adminuser-email-error').text('Please provide a valid email')
    }
    
  }

})

function check_admin_user_add_params(fname,lname,email,password){
  clear_errors()
  flag=true
  if(fname==''){
    print_empty_warning('#adminuser-first-name-error')
    flag = false
  }
  if(lname==''){
    print_empty_warning('#adminuser-last-name-error')
    flag = false
  }
  if(email==''){
    print_empty_warning('#adminuser-email-error')
    flag = false
  }
  if(password==''){
    print_empty_warning('#adminuser-pass-error')
    flag = false
  }
  return flag
}

function print_empty_warning(id){
  $(id).text('Field can not be empty')
}

function clear_errors(){
  $('#adminuser-first-name-error').text('')
  $('#adminuser-last-name-error').text('')
  $('#adminuser-email-error').text('')
  $('#adminuser-pass-error').text('')
}


function add_user(user){
  $.ajax({
    url: '/admin/add_user',
    method: 'POST',
    data: { info: user, authenticity_token: $('meta[name="csrf-token"]').attr('content') },
    success: function(response) {
 
    },
    error: function(xhr, status, error) {
  
    }
    });
  
}

function show_toast(msg){
  var toastElList = [].slice.call(document.querySelectorAll('.toast'))
  var toastList = toastElList.map(function(toastEl) {
    $(toastEl).children()[1].innerHTML=msg
    return new bootstrap.Toast(toastEl)
  })
  toastList.forEach(toast => toast.show())
}

$('.make-hr').on('click',function(){

  change_role($(this).val(),1)
  
})

$('.make-admin').on('click',function(){

  change_role($(this).val(),2)

})

$('#add-task-categories').on('click',function(){
  $('#addTaskCategoriesModal').modal('show')
})

$('#add-task-caregory').on('click',function(){
  category=$('#input-category').val()
  $('#input-category').val('')
  if(category==''){
    $('#task-category-error').text('Please provide a category name , Field cannot be empty')
  }
  else{
    $('#task-category-error').text('')
    addCategory(category)
  }
  
})

$(document).on('click','.del-task-category',function(e){
  console.log($(this).attr('value'))
  removeCategory($(this).attr('value'))
})

$(document).on('click','.edit-task-category',function(e){
  let item_id = $(this).attr('value')
  $('#category-list-'+item_id).addClass('d-none')
  $('#category-edit-container-'+item_id).removeClass('d-none')
})

$(document).on('click','.category-edit-save',function(e){
  let item_id = $(this).attr('value')
  let category_name = $('#category-edit-input-'+item_id).val()
  $('#category-list-'+item_id+' p').text(category_name)
  $('#category-list-'+item_id).removeClass('d-none')
  $('#category-edit-container-'+item_id).addClass('d-none')

  $.ajax({

    url:'/admin/task_category/'+item_id,
    method:'PATCH',
    data:{id: item_id, task_name: category_name,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      if (data){
        show_toast("Task Category Updated successfully")
      }
    },
    error:function(err){

    }

  })

})

function change_role(_id,_role){
  $.ajax({

    url:'/admin/change_role',
    method:'PATCH',
    data:{id: _id,role: _role,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      if(_role=="2"){
        show_toast("Admin created successfully")
      }
      else{
        show_toast("HRD created successfully")
      }
    },
    error:function(err){

    }

  })

}

function addCategory(category){
  $.ajax({

    url:'/admin/task_category',
    method:'POST',
    data:{data: category,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      show_toast("Category created successfully")
    },
    error:function(err){
      
    }

  })
}

function removeCategory(_id){

  $.ajax({
    url:'/admin/task_category/'+_id,
    method:'DELETE',
    data:{id: _id,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      show_toast("Category Deleted successfully")
    },
    error:function(err){
      
    }

  })
}

$('#assign-task-to-user').on('click', function(){

  $('#task-add-modal').modal('show');

})

$('#assign-task').on('click',function(){
  let _task_name=$('#task-name').val()
  let _task_category=$('#task-category').find(":selected").val();
  let _task_date=$('#task-date').val()
  let _task_time=$('#task-time').val()
  let _task_des=$('#description').val()

  let _assign_to=$('#assign-to').find(":selected").val()
  let _task_priority=$('#task-priority').find(":selected").val()
  let _notification_interval=$('input[name=Interval]:checked').val()
  let _sub_task={}
  var listItems = $("#sub-task-list li");
  listItems.each(function(idx, li) {
      var product = $(li).text();
      _sub_task[idx]=product;
      
  });

  if(check_validation(_task_name,_task_des,_task_category,_task_date,_task_time,_assign_to,_task_priority,_notification_interval)){
    const data={
      task_name:_task_name,
      task_category:_task_category,
      task_date:_task_date,
      task_time:_task_time,
      task_des:_task_des,
      assign_to:_assign_to,
      sub_task:_sub_task,
      task_importance:_task_priority,
      notification_interval:_notification_interval
    }
  
    $.ajax({
      url:'/dashboard/assigntask/tasks',
      method:'POST',
      data:{task_data:data ,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
      success:function(data){
        // show_toast("Admin created successfully")
      },
      error:function(err){
  
      }
    })

  }
})

function check_validation(task_name,task_des,task_category,task_date,task_time,assign_to,task_priority,notification_interval){
  
  refresh_assign_task_model()
  valid=true
  if(task_name== ''){
    $('#task-name-error').text("Field Can not be empty")
    valid=false
  }
  if(task_des==''){
    $('#task-des-error').text("Field Can not be empty")
    valid=false
  }
  if(task_category=='Choose...'){
    $('#task-category-error').text("Field Can not be empty")
    valid=false
  }
  if(task_date==''){
    $('#task-date-error').text("Field Can not be empty")
    valid=false
  }
  if(task_time==''){
    $('#task-time-error').text("Field Can not be empty")
    valid=false
  }
  if(assign_to=='Choose...'){
    $('#assign-to-error').text("Field Can not be empty")
    valid=false
  }
  if(task_priority=='Choose...'){
    $('#task-priority-error').text("Field Can not be empty")
    valid=false
  }
  if(notification_interval==undefined){
    $('#repeat-interval-error').text("Field Can not be empty")
    valid=false
  }

  return valid
}

function refresh_assign_task_model(){
  $('#task-name-error').text('')
  $('#task-des-error').text('')
  $('#task-category-error').text('')
  $('#task-date-error').text('')
  $('#task-time-error').text('')
  $('#assign-to-error').text('')
  $('#task-priority-error').text('')
  $('#repeat-interval-error').text('')
}

let sub_task_count=0;
$('#add-subtask').on('click', function(){
  add_sub_task()
})

$('#sub-task-input').keypress(function (e) {
  var key = e.which;
  if(key == 13)  // the enter key code
  {
    add_sub_task()
  }
});

function add_sub_task(){
  let sub_task=$('#sub-task-input').val();
  $('#sub-task-list').append(`<li class="list-group-item d-flex justify-content-between align-items-start" id="sub-task-${sub_task_count}">${sub_task} <a class="btn btn-danger del-sub-task" id="${sub_task_count}"><i class="fa fa-trash"></i></a></li>`);
  sub_task_count=sub_task_count+1
  $('#sub-task-input').val('')
}

$(document).on('click','.del-sub-task',function(e){
  $('#sub-task-'+$(this).attr('id')).remove()
})


document.addEventListener('turbolinks:load', function() {
  $(document).off('click', '.approve_task_btn', approveTaskHandler);
  $(document).on('click', '.approve_task_btn', approveTaskHandler);
  $(document).off('change', '.task-status-change', taskStatusChangeHandler);
  $(document).on('change', '.task-status-change', taskStatusChangeHandler);
});

function taskStatusChangeHandler() {
  let data={
    id: $(this)[0].id,
    status: $(this).val()
  }
  $.ajax({
    url:'/tasks/change_task_status',
    method:'PATCH',
    data:{task_data:data ,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
    },
    error:function(err){
    }
  })
}

$(document).on('change','.subtask-status-change', function(){
  let data={
    id: $(this)[0].id,
    status: $(this).val()
  }
  $.ajax({
    url:'/tasks/change_subtask_status',
    method:'PATCH',
    data:{subtask_data:data ,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
    },
    error:function(err){
    }
  })
})

$(document).on('change','.day-filter', function(){
  check_filter($(this).attr('data'));
})

$(document).on('change','.priority-filter', function(){
  check_filter($(this).attr('data'));
})

function check_filter(status){
  let _day= $(`#${status}-day-filter`).val()
  let _priority= $(`#${status}-priority-filter`).val()

  let data={
    identify:status
  }
  data['day']=_day
  if(_day=="1"){

    if(_priority!="3"){
      data['priority']=_priority
    }
  }
  else{
    
    
    if(_priority!="3"){
      data['priority']=_priority
    }
  }
  
  $.ajax({
    url:'/tasks/apply_filters',
    method:'GET',
    data:{filters:data ,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
    },
    error:function(err){
    }
  })
  
}

$('#mark-as-read').on('click', function () {
  $.ajax({
    url:'/dashboard/mark_all_read',
    method:'PUT',
    data:{authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
    },
    error:function(err){
    }
  })
})


$('.search-btn').on('click', function(){
  let _status=$(this).attr('data')
  let _query=$(`#${_status}-search-bar`).val()
  if (_query==''){
    _query="*"
  }
  let search_data={
    query: _query,
    status: _status
  }
  console.log(search_data)
  $.ajax({
    url:'/tasks/search',
    method:'GET',
    data:{search:search_data,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
    },
    error:function(err){
    }
  })
})

document.addEventListener('turbolinks:load', function() {
  $(document).off('click', '.approve_task_btn', approveTaskHandler);
  $(document).on('click', '.approve_task_btn', approveTaskHandler);
});

function approveTaskHandler() {
  let _id = $(this).attr('data');
  if (confirm('Really approve the task?')) {
    $.ajax({
      url: '/dashboard/assigntask/approve_task',
      method: 'PATCH',
      data: { id: _id, authenticity_token: $('meta[name="csrf-token"]').attr('content') },
      success: function (data) {
        // Handle success if needed
      },
      error: function (err) {
        // Handle error if needed
      }
    });
  }
}

$('#send-to-hr-btn').on('click', function(){
  $('#sendTaskModal').modal('show');
})

$('.hr-send-btn').on('click', function(){
  let _id = $(this).attr('data')
  $.ajax({
    url:'/admin/send_to_hr',
    method:'PATCH',
    data:{id: _id,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
      show_toast("Task has been sent to HR Department")
    },
    error:function(err){
    }
  })
})

$('#user-search-btn').on('click',function(){
  let query= $('#user-search').val()
  if (query==''){
    query="*"
  }
  $.ajax({
    url:'/admin/search_user',
    method:'GET',
    data:{query:query,authenticity_token: $('meta[name="csrf-token"]').attr('content')},
    success:function(data){
    },
    error:function(err){
    }
  })
})

$(document).ready(function() {
  $('#attachment_form').submit(function(event) {
    const fileInput = $('#upload_attachments');
    const submitBtn = $('#submit_btn');
    if (!fileInput[0].files || !fileInput[0].files[0]) {
      event.preventDefault();
      alert('Please choose a file.');
      
    }
  });
});
