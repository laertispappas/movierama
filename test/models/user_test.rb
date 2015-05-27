require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(fname: 'laertis', lname: 'pappas', email: 'laertis.pappas@gmail.com', password: 'pappaspappas', password_confirmation: 'pappaspappas')
  end

  test 'user should be valid' do
    assert @user.valid?
  end

  test 'fname should be present' do
    @user.fname = ' '
    assert_not @user.valid?
  end

  test 'fname should not be too short' do
    @user.fname = 'aaa'
    assert_not @user.valid?
  end

  test 'fname should not be too long' do
    @user.fname = 'a'*41
    assert_not @user.valid?
  end

  test 'lname should be present' do
    @user.lname = ' '
    assert_not @user.valid?
  end

  test 'lname should not be too short' do
    @user.lname = 'aaa'
    assert_not @user.valid?
  end

  test 'lname should not be too long' do
    @user.lname = 'a' * 41
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'email should be within bounds' do
    @user.email = 'a'*101 + '@example.com'
    assert_not @user.valid?
  end

  test 'email address should be unique' do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase # ensure case insensitive
    @user.save
    assert_not dup_user.valid?
  end

  test 'email validation should accept valid email addresses' do
    valid_addresses = %w[user@eee.com R-RAILS-GR@cs.unipi.gr first.last@papas.com lapis+papas@uni.cm]
    valid_addresses.each do |va|
      @user.email = va
      assert @user.valid?, "#{va.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid email addresses' do
    invalid_addresses = %w[user@example,com user_at_unipi.org user.name@example eee@i_am_.com foo@papas+aar.com]
    invalid_addresses.each do |ia|
      @user.email = ia
      assert_not @user.valid?, '#{va.inspect} should be invalid'
    end
  end
end
