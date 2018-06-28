import UserInfo from 'discourse/components/user-info';

export default UserInfo.extend({
  classNameBindings: [":user-info", ":user-team-info", "size"],
  size: 'large',
});
