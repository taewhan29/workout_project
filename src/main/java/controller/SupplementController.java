package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import common.DBConnection;
import supplement.SupplementDAO;
import supplement.SupplementDTO;

@WebServlet("/supplements")
public class SupplementController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SupplementDAO dao = new SupplementDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        String userName = "";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT name FROM Users WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                userName = rs.getString("name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        
        request.setAttribute("userName", userName);
        
        String action = request.getParameter("action");
        if("take".equals(action)) {
            String idParam = request.getParameter("supp_id");
            String dosageParam = request.getParameter("dosage");
            if(idParam != null && dosageParam != null) {
                dao.takeSupplement(Integer.parseInt(idParam), Integer.parseInt(dosageParam));
            }
            response.sendRedirect(request.getContextPath() + "/supplements");
            return;
        }
        
        List<SupplementDTO> list = dao.getSupplementsByUserId(userId);
        request.setAttribute("supplementsList", list);
        request.getRequestDispatcher("/supplementList.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if("insert".equals(action)) {
            String suppName = request.getParameter("supp_name");
            String brand = request.getParameter("brand");
            
            double inputKg = Double.parseDouble(request.getParameter("current_servings_kg"));
            int dosageG = Integer.parseInt(request.getParameter("dosage_g"));
            double thresholdKg = Double.parseDouble(request.getParameter("min_threshold_kg"));
            
            SupplementDTO dto = new SupplementDTO();
            dto.setUserId(userId);
            dto.setSuppName(suppName);
            dto.setBrand(brand);
            dto.setCurrentServings(inputKg * 1000.0);
            dto.setDosage(dosageG);
            dto.setMinThreshold(thresholdKg * 1000.0);
            
            dao.insertSupplement(dto);
            response.sendRedirect(request.getContextPath() + "/supplements");
            return;
        }
        
        doGet(request, response);
    }
}