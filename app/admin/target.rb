ActiveAdmin.register Target do
  filter :topic
  scope :all, default: true
  menu priority: 4, label: proc { I18n.t('api.admin.target.target_dashboard') }

  index do
    column('Id', :id)
    column('Title', :title)
    column('Topic Name', :topic)
    column('Radius', :radius)
    column('Latitude', :latitude)
    column('Longitude', :longitude)
  end
end
