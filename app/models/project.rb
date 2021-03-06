class Project < ActiveRecord::Base
  belongs_to :tenant
  # dependent: :destroy mean if project delete then artifacts also delete all
  has_many :artifacts, dependent: :destroy
  validates_uniqueness_of :title
  #custome validated function
  validate :free_plan_can_only_have_one_project  
  
  def free_plan_can_only_have_one_project
    if self.new_record? && (tenant.projects.count > 0 ) && (tenant.plan == 'free')
      errors.add(:base, "Free plans cannot have more than one project")
    end
  end
  
  def self.by_user_plan_and_tenant(tenant_id, current_user)
    tenant = Tenant.find(tenant_id)
    if tenant.plan == 'premium'
      tenant.projects
    else
      tenant.projects.order(:id).limit(1)
    end
  end
  
end
