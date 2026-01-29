# test_ldap.py
import ldap3
import sys

# === 这里填你刚才在 lims_login 里写的配置 ===
LDAP_HOST = '10.30.61.223'
LDAP_PORT = 3890
BASE_DN = 'dc=beamline,dc=local'

def test_connection(username, password):
    print(f"[-] 正在尝试连接: {LDAP_HOST}:{LDAP_PORT}")
    
    # 拼凑 DN
    user_dn = f"uid={username},ou=people,{BASE_DN}"
    print(f"[-] 构造的用户 DN: {user_dn}")

    try:
        # 1. 建立连接
        server = ldap3.Server(LDAP_HOST, port=LDAP_PORT, get_info=ldap3.ALL)
        conn = ldap3.Connection(server, user=user_dn, password=password)
        
        # 2. 尝试 Bind
        print("[-] 正在验证密码...")
        if not conn.bind():
            print(f"[X] 验证失败！结果: {conn.result}")
            return False
        
        print(f"[!] 成功！用户 {username} 密码正确。")
        print(f"[-] 服务器信息: {server.info}")
        conn.unbind()
        return True

    except Exception as e:
        print(f"[X] 发生程序错误: {str(e)}")
        return False

if __name__ == "__main__":
    # 使用方法：python test_ldap.py 用户名 密码
    if len(sys.argv) < 3:
        print("用法: python test_ldap.py [用户名] [密码]")
        print("例如: python test_ldap.py zhangsan 123456")
    else:
        u = sys.argv[1]
        p = sys.argv[2]
        test_connection(u, p)