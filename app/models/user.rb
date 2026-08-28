class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy
  has_many :labels, dependent: :destroy

  before_validation :downcase_email
  before_update :prevent_last_admin_demotion
  before_destroy :prevent_last_admin_destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def prevent_last_admin_demotion
    return unless will_save_change_to_admin?
    return unless admin == false
    return unless User.where(admin: true).count == 1

    errors.add(:base, "管理者が0人になるため権限を変更できません")
    throw(:abort)
  end

  def prevent_last_admin_destroy
    return unless admin?
    return unless User.where(admin: true).count == 1

    errors.add(:base, "管理者が0人になるため削除できません")
    throw(:abort)
  end
end