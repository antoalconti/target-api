ActiveAdmin.register User do
  filter :full_name
  filter :gender
  scope :all, default: true
  menu priority: 3, label: proc { I18n.t('api.admin.user.user_dashboard') }

  index do
    column('Id', :id)
    column('Full Name', :full_name)
    column('Gender', :gender)
    column('Email', :email)
  end
end
