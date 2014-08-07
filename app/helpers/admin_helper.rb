module AdminHelper
  def describe_instance(i)
    link_to [i.team.certname, i.service.name].join(' '), admin_instance_path(i)
  end

  def time_ago(t)
    time_ago_in_words(t, include_seconds: true) + ' ago'
  end

  def none_able(v)
     v or content_tag(:em, 'none')
  end
end
