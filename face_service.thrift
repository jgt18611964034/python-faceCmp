namespace cpp face_service
namespace py face_service

// 人脸矩形框
struct TRect {
1: i32 x,
2: i32 y,
3: i32 width,	
4: i32 height
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////	属性部分  //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 人脸属性请求
struct FaceAttrRequest {
1: binary image						// 可能包含人脸的图片
}

// 人脸属性响应
struct FaceAttrResponse {
1: i32 code,						// 返回值，0表示正确，非0表示错误
2: string message,					// 结果描述信息
3: list<map<string, i32>> attr		// 图片中所有人脸属性描述
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////	比对部分  //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 人脸比对请求
struct FaceCmpRequest {
1: binary src_image,				// 可能包含人脸的图片
2: binary dst_image,				// 可能包含人脸的图片
}

// 人脸比对响应
struct FaceCmpResponse {
1: i32 code,						// 返回值，0表示正确，非0表示错误
2: string message,					// 结果描述信息
3: TRect src_face_rect,				// src_image中最大人脸位置
4: TRect dst_face_rect,				// dst_image中最大人脸位置
5: double cmp_simi					// 人脸相似度
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////	检索部分  //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 目标信息(库中)
struct SampleInfo {
1: string name,						// 人物名
2: string pic_url,					// 人物示例图片
3: TRect face_rect					// 人物人脸在示例图片中的位置
}

// 人脸信息(请求图片)
struct FaceRetrievalInfo {
1: TRect face_rect,					// 人脸位置
2: double face_conf,			 	// 人脸位置检测准确度
3: double cmp_simi,					// 与库中最相似人脸的相似度
4: SampleInfo sample_info			// 与库中最相似人物样本信息
}

// 人脸检索请求
struct FaceRetrievalRequest {
1: binary image,					// 图片
2: list<string> target_name			// 人物过滤列表
}

// 人脸检索响应
struct FaceRetrievalResponse {
1: i32 code,						// 返回值，0表示正确，非0表示错误
2: string message,					// 结果描述信息
3: list<FaceRetrievalInfo> face_info			// 图片中出现的人脸的信息
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////	查询部分  //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 人脸库人物名列表响应
struct SampleListResponse {
1: i32 code,						// 返回值，0表示正确，非0表示错误
2: string message,					// 结果描述信息
3: list<string> sample_names		// 库中人物名列表
}

// 人脸库人物图片列表响应
struct SamplePicUrlResponse {
1: i32 code,						// 返回值，0表示正确，非0表示错误
2: string message,					// 结果描述信息
3: list<string> sample_urls			// 库中人物图片列表
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////	删除部分  //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 删除库人物信息
struct SampleDelInfo {
1: string name,						// 要从库中删除的人物名
2: optional string uri				// 对应的图片地址，可选，如无该字段，则删除所有名为name的人
}
// 请求
struct SampleDelRequest {
1: list<SampleDelInfo> sample_list	// 要从库中删除的人物信息
}


////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////	增加部分  //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 增加库人物信息请求
struct SampleAddInfo {
1: string name,						// 要增加到库中的人物名
2: binary image,					// 图片文件
3: string uri						// 对应的图片地址
}
// 请求
struct SampleAddRequest {
1: list<SampleAddInfo> sample_list	// 要增加到库中的人物信息
}
// 响应
struct SampleAddResponse {
1: i32 code,							// 0：表示正确，非0表示错误
2: string message,							// 结果描述信息
3: list<string> failed_list			// 添加失败的图片URL列表，失败原因包括下载失败，无人脸或多个人脸等
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////	服务部分  //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 服务：人脸服务
service FaceService {
	// 人脸属性服务
	FaceAttrResponse GetFaceAttr(1:FaceAttrRequest req),

	// 人脸比对服务
	FaceCmpResponse CompareFaces(1:FaceCmpRequest req),
	
	// 人脸检索服务
	FaceRetrievalResponse RetrieveFaces(1:FaceRetrievalRequest req),
	
	// 获取库中所有人物名	
	SampleListResponse GetSampleNames(),
	
	// 获取库中指定人物的所有照片URL	
	SamplePicUrlResponse GetSamplePicURL(1:string name),
	
	// 向库中增加人物
	SampleAddResponse AddSamples(1:SampleAddRequest req),
	
	// 删除库中人物
	i32 DelSamples(1:SampleDelRequest req)	// 返回被删除的个数
	
}