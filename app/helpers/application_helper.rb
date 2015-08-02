module ApplicationHelper
  def body_class(options = {})
    extra_body_classes_symbol = options[:extra_body_classes_symbol] || :extra_body_classes
    qualified_controller_name = controller.controller_path.gsub('/','-')
    basic_body_class = "#{qualified_controller_name} #{qualified_controller_name}-#{controller.action_name}"

    if content_for?(extra_body_classes_symbol)
      [basic_body_class, content_for(extra_body_classes_symbol)].join(' ')
    else
      basic_body_class
    end
  end

  def team_logo(team)
    team_id = team if team.is_a? Integer
    team_id = team if team.is_a? String
    team_id = team.id if team.is_a? Team

    image_tag "teams/#{team_id}.png", class: 'team_logo'
  end
end
