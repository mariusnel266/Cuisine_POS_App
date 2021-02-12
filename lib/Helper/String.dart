import 'package:eshop/Helper/Constant.dart';

final String getSliderApi = baseUrl + 'get_slider_images';
final String getCatApi = baseUrl + 'get_categories';
final String getSectionApi = baseUrl + 'get_sections';
final String getSettingApi = baseUrl + 'get_settings';
final String getSubcatApi = baseUrl + 'get_subcategories_by_category_id';
final String getProductApi = baseUrl + 'get_products';
final String manageCartApi = baseUrl + 'manage_cart';
final String getUserLoginApi = baseUrl + 'login';
final String getUserSignUpApi = baseUrl + 'register_user';
final String getVerifyUserApi = baseUrl + 'verify_user';
final String setFavoriteApi = baseUrl + 'add_to_favorites';
final String removeFavApi = baseUrl + 'remove_from_favorites';
final String getRatingApi = baseUrl + 'get_product_rating';
final String getCartApi = baseUrl + 'get_user_cart';
final String getFavApi = baseUrl + 'get_favorites';
final String setRatingApi = baseUrl + 'set_product_rating';
final String getNotificationApi = baseUrl + 'get_notifications';
final String getAddressApi = baseUrl + 'get_address';
final String deleteAddressApi = baseUrl + "delete_address";
final String getResetPassApi = baseUrl + 'reset_password';
final String getCitiesApi = baseUrl + 'get_cities';
final String getAreaByCityApi = baseUrl + 'get_areas_by_city_id';
final String getUpdateUserApi = baseUrl + 'update_user';
final String getAddAddressApi = baseUrl + 'add_address';
final String updateAddressApi = baseUrl + 'update_address';
final String placeOrderApi = baseUrl + 'place_order';
final String validatePromoApi = baseUrl + 'validate_promo_code';
final String getOrderApi = baseUrl + 'get_orders';
final String updateOrderApi = baseUrl + 'update_order_status';
final String updateOrderItemApi = baseUrl + 'update_order_item_status';
final String paypalTransactionApi = baseUrl + 'get_paypal_link';
final String addTransactionApi = baseUrl + 'add_transaction';
final String getJwtKeyApi = baseUrl + 'get_jwt_key';
final String getOfferImageApi = baseUrl + 'get_offer_images';
final String getFaqsApi = baseUrl + 'get_faqs';
final String updateFcmApi = baseUrl + 'update_fcm';
final String getWalTranApi = baseUrl + 'transactions';





final String ISFIRSTTIME = 'isfirst$appName';

const String ID = 'id';
const String TYPE = 'type';
const String TYPE_ID = 'type_id';
const String IMAGE = 'image';
const String IMGS='images[]';
const String NAME = 'name';
const String SUBTITLE = 'subtitle';
const String TAX = 'tax';
const String SLUG = 'slug';
const String TITLE = 'title';
const String PRODUCT_DETAIL = 'product_details';
const String DESC = 'description';
const String CATID = 'category_id';
const String CAT_NAME = 'category_name';
const String OTHER_IMAGE = 'other_images_md';
const String PRODUCT_VARIENT = 'variants';
const String PRODUCT_ID = 'product_id';
const String PRICE = 'price';
const String MEASUREMENT = 'measurement';
const String MEAS_UNIT_ID = 'measurement_unit_id';
const String SERVE_FOR = 'serve_for';
const String SHORT_CODE = 'short_code';
const String STOCK = 'stock';
const String STOCK_UNIT_ID = 'stock_unit_id';
const String DIS_PRICE = 'special_price';
const String CURRENCY = 'currency';
const String SUB_ID = 'subcategory_id';
const String SORT = 'sort';
const String PSORT = 'p_sort';
const String ORDER = 'order';
const String PORDER = 'p_order';
const String DEL_CHARGES='delivery_charges';
const String FREE_AMT='minimum_free_delivery_order_amount';



const String LIMIT = 'limit';
const String OFFSET = 'offset';
const String PRIVACY_POLLICY = 'privacy_policy';
const String TERM_COND = 'terms_conditions';
const String CONTACT_US = 'contact_us';
const String ABOUT_US = 'about_us';
const String BANNER = 'banner';
const String CAT_FILTER = 'has_child_or_item';
const String PRODUCT_FILTER = 'has_empty_products';
const String RATING = 'rating';
const String IDS = 'ids';
const String VALUE = 'value';
const String ATTRIBUTES = 'attributes';
const String ATTRIBUTE_VALUE_ID = 'attribute_value_ids';
const String IMAGES='images';
const String NO_OF_RATE = 'no_of_ratings';
const String ATTR_NAME = 'attr_name';
const String VARIENT_VALUE = 'variant_values';
const String COMMENT = 'comment';
const String MESSAGE = 'message';
const String DATE = 'date_sent';
const String TRN_DATE='transaction_date';
const String SEARCH = 'search';
const String PAYMENT_METHOD = 'payment_method';
const String ISWALLETBALUSED = "is_wallet_used";
const String WALLET_BAL_USED = 'wallet_balance_used';
const String USERDATA = 'user_data';
const String DATE_ADDED = 'date_added';
const String ORDER_ITEMS = 'order_items';
const String TOP_RETAED = 'top_rated_product';
const String WALLET='wallet';
const String CREDIT='credit';


const String USER_NAME = 'user_name';
const String USERNAME = 'username';
const String ADDRESS = 'address';
const String EMAIL = 'email';
const String MOBILE = 'mobile';
const String CITY = 'city';
const String DOB = 'dob';
const String AREA = 'area';
const String PASSWORD = 'password';
const String STREET = 'street';
const String PINCODE = 'pincode';
const String FCM_ID = 'fcm_id';
const String LATITUDE = 'latitude';
const String LONGITUDE = 'longitude';
const String USER_ID = 'user_id';
const String FAV = 'is_favorite';
const String ISRETURNABLE = 'is_returnable';
const String ISCANCLEABLE = 'is_cancelable';
const String ISPURCHASED = 'is_purchased';
const String ISOUTOFSTOCK = 'out_of_stock';
const String PRODUCT_VARIENT_ID = 'product_variant_id';
const String QTY = 'qty';
const String CART_COUNT = 'cart_count';
const String DEL_CHARGE = 'delivery_charge';
const String SUB_TOTAL = 'sub_total';
const String TAX_AMT = 'tax_amount';
const String TAX_PER = 'tax_percentage';
const String CANCLE_TILL='cancelable_till';
const String ALT_MOBNO = 'alternate_mobile';
const String STATE = 'state';
const String COUNTRY = 'country';
const String ISDEFAULT = 'is_default';
const String LANDMARK = 'landmark';
const String CITY_ID = 'city_id';
const String AREA_ID = 'area_id';
const String HOME = 'Home';
const String OFFICE = 'Office';
const String OTHER = 'Other';
const String FINAL_TOTAL = 'final_total';
const String PROMOCODE = 'promo_code';
const String NEWPASS = 'new';
const String OLDPASS = 'old';
const String MOBILENO = 'mobile_no';
const String DELIVERY_TIME = 'delivery_time';
const String DELIVERY_DATE = 'delivery_date';
const String QUANTITY = "quantity";
const String PROMO_DIS = 'promo_discount';
const String WAL_BAL = 'wallet_balance';
const String TOTAL = 'total';
const String TOTAL_PAYABLE = 'total_payable';
const String STATUS = 'status';
const String TOTAL_TAX_PER = 'total_tax_percent';
const String TOTAL_TAX_AMT = 'total_tax_amount';
const String PRODUCT_LIMIT = "p_limit";
const String PRODUCT_OFFSET = "p_offset";
const String SEC_ID = 'section_id';
const String COUNTRY_CODE = 'country_code';
const String ATTR_VALUE = 'attr_value_ids';
const String MSG = 'message';
const String ORDER_ID = 'order_id';
const String IS_SIMILAR='is_similar_products';
const String PLACED = 'received';
const String SHIPED = 'shipped';
const String PROCESSED = 'processed';
const String DELIVERD = 'delivered';
const String CANCLED = 'cancelled';
const String RETURNED = 'returned';
const String ITEM_RETURN = 'Item Return';
const String ITEM_CANCEL = 'Item Cancel';
const String ADD_ID = 'address_id';
const String STYLE = 'style';
const String SHORT_DESC = 'short_description';
const String DEFAULT = 'default';
const String STYLE1 = 'style_1';
const String STYLE2 = 'style_2';
const String STYLE3 = 'style_3';
const String STYLE4 = 'style_4';
const String ORDERID = 'order_id';
const String OTP="otp";
const String DELIVERY_BOY_ID='delivery_boy_id';
const String ISALRCANCLE = 'is_already_cancelled';
const String ISALRRETURN = 'is_already_returned';
const String ISRTNREQSUBMITTED = 'return_request_submitted';
const String OVERALL='overall_amount';
const String AVAILABILITY = 'availability';
const String MADEIN = 'made_in';
const String INDICATOR = 'indicator';
const String STOCKTYPE='stock_type';
const String SAVE_LATER='is_saved_for_later';
const String ATT_VAL='attribute_values';
const String ATT_VAL_ID='attribute_values_id';
const String FILTERS='filters';
const String TOTALALOOW='total_allowed_quantity';
const String KEY = 'key';
const String AMOUNT = 'amount';
const String CONTACT = 'contact';
const String TXNID = 'txn_id';
const String SUCCESS = 'Success';
const String ACTIVE_STATUS = 'active_status';
const String WAITING = 'awaiting';
const String TRANS_TYPE='transaction_type';
const String QUESTION="question";
const String ANSWER="answer";
const String INVOICE="invoice_html";
const String APP_THEME="App Theme";
const String SHORT="short_description";

const String CITYNAME = "cityName";
const String AREANAME = "areaName";
const String LAGUAGE_CODE = 'languageCode';

const String DEFAULT_SYSTEM="System default";
const String LIGHT="Light";
const String DARK="Dark";
String ISDARK="";
const String PAYPAL_RESPONSE_URL =
    "http://eshop.wrteam.in/app/v1/api/app_payment_status"; //?amt=10.00&cc=USD&item_name=Welcome%20&item_number=7&st=Completed&tx=50X78734DF4190710";'

String CUR_CURRENCY = '';
String CUR_USERID = '';
String CUR_USERNAME = '';
String CUR_CART_COUNT = "";
String CUR_BALANCE = '';
String RETURN_DAYS='';
String MAX_ITEMS='';
bool ISFLAT_DEL=true;
bool extendImg=true;

double deviceHeight;
double deviceWidth;
