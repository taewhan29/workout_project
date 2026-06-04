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
import physical.PhysicalInfoDAO;
import physical.PhysicalInfoDTO;

@WebServlet("/physicalInfo")
public class PhysicalInfoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PhysicalInfoDAO dao = new PhysicalInfoDAO();

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

        List<PhysicalInfoDTO> list = dao.getHistoryByUserId(userId);
        request.setAttribute("physicalHistoryList", list);
        request.getRequestDispatcher("/physicalHistory.jsp").forward(request, response);
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
        
        if (action == null || "insert".equals(action)) {
            try {
                String dateStr = request.getParameter("measuer_date");
                double weight = Double.parseDouble(request.getParameter("weight"));
                double musdeMass = Double.parseDouble(request.getParameter("musde_mass"));
                double bodyFatPct = Double.parseDouble(request.getParameter("body_fat_pct"));

                PhysicalInfoDTO dto = new PhysicalInfoDTO();
                dto.setUserId(userId);
                dto.setMeasuerDate(java.sql.Date.valueOf(dateStr));
                dto.setWeight(weight);
                dto.setMusdeMass(musdeMass);
                dto.setBodyFatPct(bodyFatPct);

                dao.insertHistory(dto);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/physicalInfo");
            return;
        }

        doGet(request, response);
    }
}