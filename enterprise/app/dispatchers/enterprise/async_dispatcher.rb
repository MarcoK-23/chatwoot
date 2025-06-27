module Enterprise::AsyncDispatcher
  def listeners
    super + [
      NavigatorListener.instance
    ]
  end
end
