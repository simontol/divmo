class MembersController < ApplicationController

def index  
  @group = Group.find(params[:group_id])
  @members = Membership.where(:group_id => params[:group_id])
end

def update
  @member = Membership.find(params[:id])
  @group = @member.group
  
  @member.role = params[:role]
  @member.save
  
  redirect_to group_members_path(@group)
end

end
