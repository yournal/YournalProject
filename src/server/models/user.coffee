module.exports.schema = ($mongoose, crypto) ->
  validate = (value) ->
    return (@provider and @provider isnt 'local') or value.length

  UserSchema = new $mongoose.Schema(
    firstName:
      type: String,
      required: true
      validate: [validate, 'First name cannot be blank.']
    lastName:
      type: String,
      required: true
      validate: [validate, 'Last name cannot be blank.']
    email:
      type: String
      required: true
      unique: true
      match: [/.+\@.+\..+/, 'Please enter a valid email.']
      validate: [validate, 'Email cannot be blank.']
    roles:
      type: Array
      default: ['authenticated']
    hashedPassword:
      type: String
      required: true
      validate: [validate, 'Password cannot be blank.']
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
    if @isNew and @provider is 'local' and @password and not @password.length
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
