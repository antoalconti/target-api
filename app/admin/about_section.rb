ActiveAdmin.register SiteInfo do
  permit_params :info

  menu priority: 4, label: proc { I18n.t('api.admin.site_info.site_info_dashboard') }

  index do
    column('Id', :id) { |site_info| link_to "##{site_info.id} ", admin_site_info_path(site_info) }
    column('Info', :info)
  end

  show do
    panel 'About Info' do
      table_for(site_info) do |t|
        t.column(:id)
        t.column(:info)
      end
    end
  end
end
