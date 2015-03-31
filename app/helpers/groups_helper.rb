module GroupsHelper
  def nested_groups(groups)
    groups.collect do |group, sub_group|
      render(group) + content_tag(:div, nested_employees(group) + nested_groups(sub_group), class: 'nested-group')
    end.join.html_safe
  end

  private

  def nested_employees(group)
    render('groups/employee', :group => group)
  end

end
