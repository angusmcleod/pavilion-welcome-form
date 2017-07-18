export default function() {
  this.route('welcome', {path: '/welcome'}, function() {
    this.route('user', {path: '/user'})
  })
}
