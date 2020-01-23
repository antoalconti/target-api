ActiveAdmin.register Topic do
  permit_params :name
  filter :name
  scope :all, default: true
  menu priority: 2, label: proc { I18n.t('api.admin.topic.topic_dashboard') }

  index do
    column('Name', sortable: :name) { |topic| link_to "##{topic.name} ", admin_topic_path(topic) }
    column('Id', :id)
  end

  show do
    panel 'Topic Info' do
      table_for(topic) do |t|
        t.column(:id)
        t.column(:name)
        t.column(:created_at)
        t.column(:updated_at)
      end
    end
  end
end
