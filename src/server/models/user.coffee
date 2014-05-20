module.exports.schema = ($mongoose) ->
  validate = (value) ->
    return (@provider and @provider isnt 'local') or value.length

  UserSchema = new $mongoose.Schema(
    name:
      type: String,
      required: true
      validate: [validate, 'Name cannot be blank']
    email:
      type: String
      required: true
      match: [/.+\@.+\..+/, 'Please enter a valid email']
      validate: [validate, 'Email cannot be blank']
    username:
      type: String
      unique: true,
      validate: [validate, 'Username cannot be blank']
    roles:
      type: Array
      default: ['authenticated']
    hashedPassword:
      type: String
      required: true
      validate: [validate, 'Password cannot be blank']
    provider:
      type: String
      default: 'local'
    salt: String
    facebook: {}
  )

  UserSchema.virtual('password').set((password) ->
    @_password = password
    @salt = @makeSalt()
    @hashedPassword = @hashPassword password
  ).get ->
    @_password

  UserSchema.pre 'save', (next) ->
    if @isNew and @provider is local and @password and not @password.length
      return next new Error('Invalid password')
    next()

  UserSchema.methods =
    authenticate: (plainText) ->
      @hashPassword(plainText) is @hashedPassword
    makeSalt: ->
      crypto.randomBytes(16).toString('base64')
    hashPassword: (password) ->
      if not password or !@salt
        return ''
      salt = new Buffer this.salt, 'base64'
      crypto.pbkdf2Sync(password, salt, 10000, 64).toString 'base64'

  return UserSchema


module.exports.model = ($connection, UserSchema) ->
  $connection.model('User', UserSchema)
