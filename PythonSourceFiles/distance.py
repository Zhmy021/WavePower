import math

def calculate_distance(lat1, lon1, lat2, lon2):
    # 将经纬度转换为弧度
    lat1_rad = math.radians(lat1)
    lon1_rad = math.radians(lon1)
    lat2_rad = math.radians(lat2)
    lon2_rad = math.radians(lon2)

    # 应用Haversine公式计算两个坐标点之间的距离
    dlon = lon2_rad - lon1_rad
    dlat = lat2_rad - lat1_rad
    a = math.sin(dlat / 2) ** 2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlon / 2) ** 2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    distance = 6371 * c  # 地球平均半径为6371公里

    return distance

def find_nearest_record(records, target_lat, target_lon):
    nearest_distance = float('inf')  # 初始最近距离设置为无穷大
    nearest_record = None

    for record in records:
        record_num, record_lon, record_lat, record_depth = record

        # 计算当前记录与目标坐标的距离
        distance = calculate_distance(target_lat, target_lon, record_lat, record_lon)

        # 如果当前距离比最近距离小，则更新最近距离和最近记录
        if distance < nearest_distance:
            nearest_distance = distance
            nearest_record = (record_num, record_lon, record_lat)

    return nearest_record


def getresult(target_lat,target_lon):
    filename = "fort.txt"
    records = []

    line_count = 0

    with open(filename, "r") as file:
        for line in file:
            line = line.strip().split()
            record_num = int(line[0])
            record_lon = float(line[1])
            record_lat = float(line[2])
            record_depth = float(line[3])
            records.append((record_num, record_lon, record_lat, record_depth))

            line_count += 1
            if line_count == 10613:
                break



    # 查找最近记录
    nearest_record, nearest_lon, nearest_lat = find_nearest_record(records, target_lat, target_lon)
    return nearest_record
