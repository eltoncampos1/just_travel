export const KEY = "@just_travel:cart"

export default  {
  mounted(){
    this.handleEvent("create_cart_session_id", map => {
      const {cartId} = map
      localStorage.setItem(KEY, cartId)
    })
  }
}