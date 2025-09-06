require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test 'all subgroups' do
    assert_equal groups(:group_gl, :group_sl, :group_o, :group_so).sort,
                 groups(:group_gl).subgroups.to_a.sort
    assert_equal groups(:group_o, :group_so).sort,
                 groups(:group_o).subgroups.to_a.sort
    assert_equal groups(:group_sl, :group_so).sort,
                 groups(:group_sl).subgroups.to_a.sort
    assert_equal [groups(:group_so)],
                 groups(:group_so).subgroups.to_a
    assert_equal groups(:group_q, :group_z).sort,
                 groups(:group_q).subgroups.to_a.sort
  end

  test 'all supergroups' do
    assert_equal groups(:group_gl, :group_sl, :group_o, :group_so).sort,
                 groups(:group_so).supergroups.sort
  end

  test 'timed affiliations' do
    Affiliation.create!({
                          group: groups(:group_so),
                          groupable: groups(:group_q),
                          start: 2.years.ago,
                          end: 1.year.ago,
                          groupable_type: 'Group'
                        })
    assert_equal groups(:group_sl, :group_so).sort,
                 groups(:group_sl).subgroups.to_a.sort

    Affiliation.create!({
                          group: groups(:group_so),
                          groupable: groups(:group_z),
                          start: 2.years.ago,
                          end: 3.years.from_now,
                          groupable_type: 'Group'
                        })
    assert_equal groups(:group_gl, :group_sl, :group_o, :group_so, :group_z).sort,
                 groups(:group_gl).subgroups.to_a.sort
  end
end
